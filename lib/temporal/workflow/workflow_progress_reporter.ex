defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletion
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus, as: SuccessStatus
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus, as: FailureStatus
  alias Temporal.CoreSdk.Data.WorkflowCommandScheduleActivity
  alias Temporal.CoreSdk.Data.WorkflowInput
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
    command_batch: [],
    sequences: %{}
  ])

  @type progress_state() :: term()

  @type schedule_activity_opts :: WorkflowCommandScheduleActivity.opts()

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
       worker: exec_ctx.worker
     )}
  end

  @spec schedule_activity(
          pid(),
          activity_type :: String.t(),
          args :: [term()],
          schedule_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_activity(reporter, activity_type, args, opts \\ []),
    do:
      GenServer.call(
        reporter,
        {:schedule_activity, activity_type, args, opts},
        :infinity
      )

  def process_activation(activation) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(activation.run_id) do
      GenServer.call(reporter, {:process_activation, activation}, :infinity)
    end
  end

  def report_completed_success(reporter, result) do
    output = WorkflowInput.with_opts!(result) |> Payload.from_workflow_input()
    GenServer.cast(reporter, {:report_completed_success, output})
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
    opts = Keyword.drop(opts, [:seq, :activity_id, :activity_type, :arguments])

    next_seq = progress_state(state, :next_seq)
    activity_id = "#{next_seq}"

    command =
      {:schedule_activity,
       [
         seq: next_seq,
         activity_id: activity_id,
         activity_type: activity_type,
         task_queue: progress_state(state, :task_queue).queue_name,
         arguments: args
       ] ++ opts}

    command_batch = progress_state(state, :command_batch) ++ [command]

    {:reply, {:ok, activity_id},
     progress_state(state, command_batch: command_batch, next_seq: next_seq + 1)}
  end

  def handle_call({:process_activation, activation}, _from, state) do
    activity_resolve_jobs =
      activation.jobs
      |> Enum.filter(&match?(%{variant: {:resolve_activity, _}}, &1))
      |> Enum.map(&elem(&1.variant, 1))

    sequences = progress_state(state, :sequences)

    {:ok, will_unlock_anything?} =
      WorkflowFlowController.will_resolutions_unlock?(
        activation.run_id,
        Enum.map(activity_resolve_jobs, fn job ->
          %{activity_id: activity_id} = sequences[job.seq]
          activity_id
        end)
      )
    Logger.info("Will resolution unlock? #{inspect(will_unlock_anything?)}")

    variants = Enum.map(activation.jobs, & &1.variant)

    # These are in a specific order
    # https://typescript.temporal.io/api/classes/proto.coresdk.workflow_activation.WorkflowActivation
    {patch_updates, variants} =
      Enum.split_with(variants, fn
        {:set_patch_marker, _} -> true
        _ -> false
      end)

    {update_seeds, variants} =
      Enum.split_with(variants, fn
        {:update_random_seed, _} -> true
        _ -> false
      end)

    {signals_updates, variants} =
      Enum.split_with(variants, fn
        {:signal_workflow, _} -> true
        {:resolve_signal_external_workflow, _} -> true
        {:do_update, _} -> true
        _ -> false
      end)

    {activity_resolutions, variants} =
      Enum.split_with(variants, fn
        {:resolve_activity, _} -> true
        _ -> false
      end)

    {:ok, state} = resolve_activities(activity_resolutions, activation, state)

    {queries, variants} =
      Enum.split_with(variants, fn
        {:query_workflow, _} -> true
        _ -> false
      end)

    {evictions, variants} =
      Enum.split_with(variants, fn
        {:remove_from_cache, _} -> true
        _ -> false
      end)

    everything =
      patch_updates ++ update_seeds ++ signals_updates ++ queries ++ evictions ++ variants

    processed =
      everything
      |> Enum.reduce({:ok, state}, fn
        {variant, job}, {:ok, state} ->
          Logger.error("Received unexpected job variant (#{inspect(variant)} - #{inspect(job)}")
          {:ok, state}

        _, {:error, err} ->
          {:error, err}
      end)

    with {:ok, new_state} <- processed do
      if !will_unlock_anything? do
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

  def handle_cast({:report_completed_success, output}, state) do
    report_successful_completion(state,
      commands: [{:complete_workflow_execution, [result: output]}]
    )
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Error reporting workflow completion - #{inspect(err)}")
        {:noreply, state}
    end
  end

  def handle_cast(:heartbeat, state) do
    report_successful_completion(state, commands: [])
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:noreply, state}
    end
  end

  def handle_continue(:heartbeat, state) do
    report_successful_completion(state, commands: [])
    |> case do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:reply, {:error, err}, state}
    end
  end

  defp resolve_activities(activities, activation, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    Enum.each(activities, fn {:resolve_activity, job} ->
      activity = sequences[job.seq]

      Logger.debug(
        "Job: resolve_activity (#{activity.activity_type} - #{activity.activity_id}) for #{activation.run_id}"
      )
    end)

    results =
      Enum.map(activities, fn {:resolve_activity, job} ->
        activity = sequences[job.seq]

        output =
          case job.result.status do
            {:completed, completed} ->
              {:ok, completed.result |> Payload.to_value()}

            {:failed, failure} ->
              {:error, failure.failure.message}

            {:cancelled, failure} ->
              {:error, {:cancelled, failure.failure.message}}

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
      Logger.warning("Resolving activity...!!!")
      {:ok, state}
    else
      {:error, err} ->
        Logger.error("Error resolving activities #{inspect(err)}")
        {:error, "Error resolving activities #{inspect(err)}"}
    end
  end

  @spec report_successful_completion(progress_state(), SuccessStatus.opts()) ::
          {:ok, state :: term()} | {:error, term()}
  defp report_successful_completion(state, completion) do
    commands = progress_state(state, :command_batch) ++ Keyword.get(completion, :commands, [])
    state = progress_state(state, command_batch: [])

    state =
      Enum.reduce(commands, state, fn
        {:schedule_activity, activity}, state ->
          sequences = progress_state(state, :sequences)

          progress_state(state,
            sequences: Map.put(sequences, activity[:seq], Map.new(activity))
          )

        _, state ->
          state
      end)

    completion = Keyword.put(completion, :commands, commands)

    resp =
      send_successful_activation_completion(
        progress_state(state, :run_id),
        progress_state(state, :runtime).core,
        progress_state(state, :worker).core,
        completion
      )

    {resp, state}
  end

  @spec send_successful_activation_completion(
          run_id :: String.t(),
          runtime :: term(),
          worker :: term(),
          SuccessStatus.opts()
        ) :: :ok | {:error, term()}
  def send_successful_activation_completion(run_id, runtime, worker, completion) do
    Logger.debug("Completed Activation: #{run_id}")

    complete_activation_msg =
      WorkflowActivationCompletion.with_opts!(
        run_id: run_id,
        status: {:successful, completion}
      )

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_workflow_activation(
          runtime,
          worker,
          complete_activation_msg,
          self()
        )
        |> case do
          :ok ->
            receive do
              {:ok, _} ->
                send(parent, {self(), :ok})

              {:error, err} ->
                send(parent, {self(), {:error, err}})
                Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
            end

          other_resp ->
            send(parent, {self(), other_resp})
        end
      end)

    receive do
      {^child, resp} ->
        resp
    end
  end

  @spec send_failure_activation_completion(
          run_id :: String.t(),
          runtime :: term(),
          worker :: term(),
          FailureStatus.opts()
        ) :: :ok | {:error, term()}
  def send_failure_activation_completion(run_id, runtime, worker, completion) do
    Logger.debug("Failed Activation: #{run_id}")

    complete_activation_msg =
      WorkflowActivationCompletion.with_opts!(
        run_id: run_id,
        status: {:failed, completion}
      )

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_workflow_activation(
          runtime,
          worker,
          complete_activation_msg,
          self()
        )
        |> case do
          :ok ->
            receive do
              {:ok, _} ->
                send(parent, {self(), :ok})

              {:error, err} ->
                send(parent, {self(), {:error, err}})
                Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
            end

          other_resp ->
            send(parent, {self(), other_resp})
        end
      end)

    receive do
      {^child, resp} ->
        resp
    end
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
