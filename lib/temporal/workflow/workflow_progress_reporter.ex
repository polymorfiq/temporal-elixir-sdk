defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  alias Temporal.Worker
  alias Temporal.Comms.Channel
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Workflows.ActivationCompletion
  alias Temporal.Comms.Workflows.Commands.ScheduleActivity
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow.WorkflowFlowController

  require Logger
  require Record

  Record.defrecordp(:progress_state, [
    :run_id,
    :workflow_id,
    :worker_id,
    :task_queue,
    :next_seq,
    :runtime,
    :worker,
    :channel,
    command_batch: [],
    sequences: %{}
  ])

  @type progress_state() :: term()

  @type schedule_activity_opts :: ScheduleActivity.schedule_activity()

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:workflow_progress_reporter, exec_ctx.run_id})

    {:ok,
     progress_state(
       run_id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       task_queue: exec_ctx.task_queue,
       next_seq: 1,
       runtime: exec_ctx.runtime,
       worker: %Worker{
         id: exec_ctx.worker_id,
         channel: exec_ctx.channel,
         task_queue: exec_ctx.task_queue
       },
       channel: exec_ctx.channel
     )}
  end

  @spec schedule_activity(
          pid(),
          activity_type :: String.t(),
          args :: [term()],
          schedule_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_activity(reporter, activity_type, args, opts \\ %{}),
    do:
      GenServer.call(
        reporter,
        {:schedule_activity, activity_type, args, opts},
        :infinity
      )

  def process_activation({:activation, run_id, _} = activation) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.call(reporter, {:process_activation, activation}, :infinity)
    end
  end

  def report_completed_success(reporter, result) do
    output = Payload.send_to_engine(result)
    GenServer.call(reporter, {:report_completed_success, output}, :infinity)
  end

  def send_heartbeat_for_id(run_id) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.cast(reporter, :heartbeat)
    end
  end

  def handle_call(
        {:schedule_activity, activity_type, args, opts},
        _from,
        state
      ) do
    # Do not let user override these
    opts = Map.drop(opts, [:seq, :activity_id, :activity_type, :arguments])

    next_seq = progress_state(state, :next_seq)
    activity_id = "#{next_seq}"

    command =
      {:schedule_activity, next_seq,
       Map.merge(
         %{
           seq: next_seq,
           activity_id: activity_id,
           activity_type: activity_type,
           task_queue: progress_state(state, :task_queue).queue_name,
           arguments: args
         },
         opts
       )}

    command_batch = progress_state(state, :command_batch) ++ [command]

    {:reply, {:ok, activity_id},
     progress_state(state, command_batch: command_batch, next_seq: next_seq + 1)}
  end

  def handle_call({:process_activation, {:activation, run_id, opts} = activation}, _from, state) do
    jobs = Keyword.fetch!(opts, :jobs)

    activity_resolve_jobs =
      jobs
      |> Enum.filter(&match?({:resolve_activity, _seq, _result, _opts}, &1))

    sequences = progress_state(state, :sequences)

    {:ok, {locked?, will_unlock_anything?}} =
      WorkflowFlowController.will_resolutions_unlock?(
        run_id,
        Enum.map(activity_resolve_jobs, fn {:resolve_activity, seq, _result, _opts} ->
          %{activity_id: activity_id} = sequences[seq]
          activity_id
        end)
      )

    Logger.debug("Will resolution unlock? #{inspect(will_unlock_anything?)}")

    # These are in a specific order
    # https://typescript.temporal.io/api/classes/proto.coresdk.workflow_activation.WorkflowActivation
    {patch_updates, jobs} =
      Enum.split_with(jobs, fn
        {:set_patch_marker, _} -> true
        _ -> false
      end)

    {update_seeds, jobs} =
      Enum.split_with(jobs, fn
        {:update_random_seed, _} -> true
        _ -> false
      end)

    {signals_updates, jobs} =
      Enum.split_with(jobs, fn
        {:signal_workflow, _} -> true
        {:resolve_signal_external_workflow, _} -> true
        {:do_update, _} -> true
        _ -> false
      end)

    {activity_resolutions, jobs} =
      Enum.split_with(jobs, fn
        {:resolve_activity, _seq, _result, _opts} -> true
        _ -> false
      end)

    {:ok, state} = resolve_activities(activity_resolutions, activation, state)

    {queries, jobs} =
      Enum.split_with(jobs, fn
        {:query_workflow, _} -> true
        _ -> false
      end)

    {evictions, jobs} =
      Enum.split_with(jobs, fn
        {:remove_from_cache, _reason, _message} -> true
        _ -> false
      end)

    everything =
      patch_updates ++ update_seeds ++ signals_updates ++ queries ++ evictions ++ jobs

    processed =
      everything
      |> Enum.reduce({:ok, state}, fn
        job, {:ok, state} ->
          Logger.error("Received unexpected job (#{inspect(job)}")
          {:ok, state}

        _, {:error, err} ->
          {:error, err}
      end)

    with {:ok, new_state} <- processed do
      if locked? && !will_unlock_anything? do
        {:reply, :ok, new_state, {:continue, :heartbeat}}
      else
        {:reply, :ok, new_state}
      end
    else
      {:error, err} ->
        Logger.error("Error when processing activation: #{inspect(err)}")
        {:reply, {:error, err}, state, {:continue, :heartbeat}}
    end
  end

  def handle_call({:report_completed_success, output}, _from, state) do
    report_successful_completion(state, [{:complete_workflow_execution, output}])
    |> case do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        Logger.error("Error reporting workflow completion - #{inspect(err)}")
        {:reply, {:error, err}, state}
    end
  end

  def handle_cast(:heartbeat, state) do
    report_successful_completion(state, [])
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:noreply, state}
    end
  end

  def handle_continue(:heartbeat, state) do
    report_successful_completion(state, [])
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:noreply, state}
    end
  end

  defp resolve_activities(activities, _activation, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    Enum.each(activities, fn {:resolve_activity, seq, _result, _opts} ->
      activity = sequences[seq]

      Logger.debug(
        "Job: resolve_activity (#{activity.activity_type} - #{activity.activity_id}) for #{run_id}"
      )
    end)

    results =
      Enum.map(activities, fn {:resolve_activity, seq, result, _opts} ->
        activity = sequences[seq]

        output =
          case result do
            {:completed, value} ->
              {:ok, value |> Payload.to_value()}

            {:failed, failure} ->
              {:error, failure}

            {:cancelled, failure} ->
              {:error, {:cancelled, failure}}

            {:will_complete_async, _} ->
              :ok
          end

        {activity.activity_id, output}
      end)

    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(run_id),
         :ok <-
           WorkflowFlowController.activity_tasks_resolved(
             flow_control,
             results
           ) do
      {:ok, state}
    else
      {:error, err} ->
        Logger.error("Error resolving activities #{inspect(err)}")
        {:error, "Error resolving activities #{inspect(err)}"}
    end
  end

  @spec report_successful_completion(progress_state(), ActivationCompletion.Success.success()) ::
          {:ok, state :: term()} | {:error, term()}
  defp report_successful_completion(state, commands) do
    commands = progress_state(state, :command_batch) ++ (commands || [])
    state = progress_state(state, command_batch: [])

    state =
      Enum.reduce(commands, state, fn
        {:schedule_activity, seq, opts}, state ->
          sequences = progress_state(state, :sequences)

          progress_state(state,
            sequences: Map.put(sequences, seq, opts)
          )

        _, state ->
          state
      end)

    resp =
      send_successful_activation_completion(
        progress_state(state, :run_id),
        progress_state(state, :worker),
        commands
      )

    {resp, state}
  end

  @spec send_successful_activation_completion(
          run_id :: String.t(),
          worker :: Worker.t(),
          commands :: [term()]
        ) :: :ok | {:error, term()}
  def send_successful_activation_completion(run_id, worker, commands) do
    Logger.debug("Completed Activation: #{run_id}")

    Channel.send_to_engine(
      worker.channel,
      worker,
      {:activation_completion, run_id, {:success, commands}}
    )
  end

  @spec send_failure_activation_completion(
          run_id :: String.t(),
          worker :: Worker.t(),
          ActivationCompletion.Failure.failure()
        ) :: :ok | {:error, term()}
  def send_failure_activation_completion(run_id, worker, completion) do
    Logger.debug("Failed Activation: #{run_id}")

    Channel.send_to_engine(
      worker.channel,
      worker,
      {:activation_completion, run_id, {:failure, completion}}
    )
  end

  def handle_info({:EXIT, _, :normal}, state) do
    {:noreply, state}
  end

  def terminate(reason, state) do
    run_id = progress_state(state, :run_id)
    Logger.debug("Workflow (#{run_id}) terminating: #{inspect(reason)}")

    reason
  end
end
