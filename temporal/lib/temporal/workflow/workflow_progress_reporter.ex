defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  require TemporalEngine.Data.ActivationCompletion

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.Jobs

  alias Temporal.Worker
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.Duration
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
    :core_worker,
    command_batch: [],
    sequences: %{}
  ])

  @type progress_state() :: term()

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
       core_worker: exec_ctx.core_worker
     )}
  end

  @spec request_start_timer(pid(), Duration.shorthand()) :: :ok | {:error, term()}
  def request_start_timer(reporter, duration),
    do:
      GenServer.call(
        reporter,
        {:command, start_timer(start_to_fire_timeout: Duration.from_tuple(duration))},
        :infinity
      )

  @spec schedule_activity(
          pid(),
          activity_type :: String.t(),
          args :: [term()],
          Commands.schedule_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_activity(reporter, activity_type, args, opts \\ []) do
    with {:ok, cmd} <-
           Commands.schedule_activity_from_opts(
             opts ++ [arguments: [], activity_type: activity_type]
           ) do
      GenServer.call(
        reporter,
        {:command,
         Commands.schedule_activity(cmd, arguments: Enum.map(args, &Payload.record_from_value/1))},
        :infinity
      )
    end
  end

  @spec schedule_local_activity(
          pid(),
          activity_type :: String.t(),
          args :: [term()],
          Commands.schedule_local_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_local_activity(reporter, activity_type, args, opts \\ []) do
    with {:ok, cmd} <-
           Commands.schedule_local_activity_from_opts(
             opts ++ [arguments: [], activity_type: activity_type]
           ) do
      GenServer.call(
        reporter,
        {:command,
         Commands.schedule_local_activity(cmd,
           arguments: Enum.map(args, &Payload.record_from_value/1)
         )},
        :infinity
      )
    end
  end

  def process_activation(activation(run_id: run_id) = activation) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.call(reporter, {:process_activation, activation}, :infinity)
    end
  end

  def report_completed_success(reporter, result) do
    output = Payload.record_from_value(result)
    GenServer.call(reporter, {:report_completed_success, output}, :infinity)
  end

  @failure_opts_schema NimbleOptions.new!(
                         message: [
                           required: true,
                           type: :string,
                           doc: "Error message to report with the failure"
                         ],
                         stack_trace: [
                           default: "",
                           type: :string,
                           doc: "Stack Trace associated with the failure, if applicable"
                         ],
                         cause: [
                           required: false,
                           type: :any,
                           doc: "Failure that led to this failure"
                         ],
                         info: [
                           required: false,
                           type: :any,
                           type_doc: "`TemporalEngine.Data.Failure.info/0`",
                           doc: "More detailed information about the type of failure"
                         ]
                       )

  @typedoc "Supported options:\n#{NimbleOptions.docs(@failure_opts_schema)}"
  @type failure_opts :: unquote(NimbleOptions.option_typespec(@failure_opts_schema))

  @spec report_completed_failure(pid(), failure_opts()) :: :ok | {:error, term()}
  def report_completed_failure(reporter, opts) do
    import TemporalEngine.Data.Failure

    with {:ok, opts} <- NimbleOptions.validate(opts, @failure_opts_schema) do
      GenServer.call(
        reporter,
        {:report_completed_failure,
         failure(
           message: opts[:message],
           stack_trace: opts[:stack_trace],
           cause: opts[:cause],
           failure_info: opts[:info]
         )},
        :infinity
      )
    end
  end

  def send_heartbeat_for_id(run_id) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.cast(reporter, :heartbeat)
    end
  end

  def handle_call({:command, start_timer() = cmd}, _from, state) do
    next_seq = progress_state(state, :next_seq)
    sequences = progress_state(state, :sequences)

    {:reply, {:ok, "#{next_seq}"},
     progress_state(state,
       sequences: Map.put(sequences, next_seq, cmd),
       command_batch: progress_state(state, :command_batch) ++ [start_timer(cmd, seq: next_seq)],
       next_seq: next_seq + 1
     )}
  end

  def handle_call({:command, schedule_activity() = cmd}, _from, state) do
    next_seq = progress_state(state, :next_seq)
    activity_id = "#{next_seq}"

    cmd =
      schedule_activity(cmd,
        seq: next_seq,
        activity_id: "#{next_seq}",
        task_queue: progress_state(state, :task_queue).queue_name
      )

    {:reply, {:ok, activity_id},
     progress_state(state,
       command_batch: progress_state(state, :command_batch) ++ [cmd],
       next_seq: next_seq + 1
     )}
  end

  def handle_call({:command, schedule_local_activity() = cmd}, _from, state) do
    next_seq = progress_state(state, :next_seq)
    activity_id = "#{next_seq}"

    cmd =
      schedule_local_activity(cmd,
        seq: next_seq,
        activity_id: "#{next_seq}"
      )

    {:reply, {:ok, activity_id},
     progress_state(state,
       command_batch: progress_state(state, :command_batch) ++ [cmd],
       next_seq: next_seq + 1
     )}
  end

  def handle_call({:process_activation, activation(run_id: run_id) = activation}, _from, state) do
    jobs = activation(activation, :jobs) |> Enum.map(&job(&1, :variant))

    activity_resolve_jobs =
      jobs
      |> Enum.filter(&match?(job(variant: resolve_activity()), &1))

    sequences = progress_state(state, :sequences)

    {:ok, {locked?, will_unlock_anything?}} =
      WorkflowFlowController.will_resolutions_unlock?(
        run_id,
        Enum.map(activity_resolve_jobs, fn resolve_activity(seq: seq) ->
          case sequences[seq] do
            schedule_activity(activity_id: activity_id) -> activity_id
            schedule_local_activity(activity_id: activity_id) -> activity_id
          end
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

    {timer_resolutions, jobs} =
      Enum.split_with(jobs, fn
        fire_timer() -> true
        _ -> false
      end)

    {:ok, state} = resolve_timers(timer_resolutions, activation, state)

    {activity_resolutions, jobs} =
      Enum.split_with(jobs, fn
        resolve_activity() -> true
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
    report_successful_completion(state, [complete_workflow_execution(result: output)])
    |> case do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        Logger.error("Error reporting workflow completion - #{inspect(err)}")
        {:reply, {:error, err}, state}
    end
  end

  def handle_call({:report_completed_failure, failure}, _from, state) do
    report_successful_completion(state, [fail_workflow_execution(failure: failure)])
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

    Enum.each(activities, fn resolve_activity(seq: seq) ->
      case sequences[seq] do
        schedule_activity(activity_id: activity_id, activity_type: activity_type) ->
          Logger.debug("Job: resolve_activity (#{activity_type} - #{activity_id}) for #{run_id}")

        schedule_local_activity(activity_id: activity_id, activity_type: activity_type) ->
          Logger.debug("Job: resolve_activity (#{activity_type} - #{activity_id}) for #{run_id}")
      end
    end)

    results =
      Enum.map(activities, fn resolve_activity(
                                seq: seq,
                                result: activity_resolution(status: result)
                              ) ->
        output =
          case result do
            activity_completed(result: value) ->
              {:ok, value |> Payload.value_from_record()}

            activity_failed(failure: failure) ->
              {:error, failure}

            activity_cancelled(failure: failure) ->
              {:error, {:cancelled, failure}}

            activity_backoff(backoff_duration: _duration) ->
              {:error,
               {:not_implemented,
                "TODO: Local Activity backoff (https://docs.rs/temporalio-common/0.4.0/temporalio_common/protos/coresdk/activity_result/struct.DoBackoff.html) not yet implemented."}}
          end

        case sequences[seq] do
          schedule_activity() = activity ->
            {schedule_activity(activity, :activity_id), output}

          schedule_local_activity() = activity ->
            {schedule_local_activity(activity, :activity_id), output}
        end
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

  defp resolve_timers(timers, _activation, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    timer_ids =
      Enum.map(timers, fn fire_timer(seq: seq) ->
        cmd = sequences[seq]

        Logger.debug(
          "Job: fire_timer (#{start_timer(cmd, :seq)} - #{inspect(start_timer(cmd, :start_to_fire_timeout))}) for #{run_id}"
        )

        "#{seq}"
      end)

    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(run_id),
         :ok <- WorkflowFlowController.timers_resolved(flow_control, timer_ids) do
      {:ok, state}
    else
      {:error, err} ->
        Logger.error("Error resolving timers #{inspect(err)}")
        {:error, "Error resolving timers #{inspect(err)}"}
    end
  end

  @spec report_successful_completion(progress_state(), ActivationCompletion.success()) ::
          {:ok, state :: term()} | {:error, term()}
  defp report_successful_completion(state, commands) do
    commands = progress_state(state, :command_batch) ++ (commands || [])
    state = progress_state(state, command_batch: [])

    state =
      Enum.reduce(commands, state, fn
        schedule_activity(seq: seq) = cmd, state ->
          sequences = progress_state(state, :sequences)

          progress_state(state,
            sequences: Map.put(sequences, seq, cmd)
          )

        schedule_local_activity(seq: seq) = cmd, state ->
          sequences = progress_state(state, :sequences)

          progress_state(state,
            sequences: Map.put(sequences, seq, cmd)
          )

        _, state ->
          state
      end)

    resp =
      send_successful_activation_completion(
        progress_state(state, :run_id),
        progress_state(state, :core_worker).core,
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

    TemporalEngine.Worker.complete_workflow_activation(
      worker,
      ActivationCompletion.completion(
        run_id: run_id,
        status:
          ActivationCompletion.success(
            commands: Enum.map(commands, &ActivationCompletion.command(variant: &1))
          )
      )
    )
  end

  @spec send_failure_activation_completion(
          run_id :: String.t(),
          worker :: Worker.t(),
          ActivationCompletion.failure()
        ) :: :ok | {:error, term()}
  def send_failure_activation_completion(run_id, worker, completion) do
    Logger.debug("Failed Activation: #{run_id}")

    TemporalEngine.Worker.complete_workflow_activation(
      worker,
      ActivationCompletion.completion(run_id: run_id, status: completion)
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
