defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.ActivityResolutionStatus
  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletion
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus, as: SuccessStatus
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

  @spec resolve_activity(
          pid(),
          activity_seq_num :: integer(),
          status :: ActivityResolutionStatus.t()
        ) :: :ok | {:error, term()}
  def resolve_activity(reporter, seq_num, status),
    do: GenServer.call(reporter, {:resolve_activity, seq_num, status}, :infinity)

  def report_completed_success(reporter, result) do
    output = WorkflowInput.with_opts!(result) |> Payload.from_workflow_input()
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

  def handle_call({:resolve_activity, seq_num, result}, _from, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    output =
      case result do
        {:completed, completed} ->
          {:ok, completed.result |> Payload.to_value()}

        {:failed, failure} ->
          {:error, failure.failure.message}

        {:cancelled, failure} ->
          {:error, {:cancelled, failure.failure.message}}

        {:will_complete_async, _} ->
          :ok
      end

    resp =
      case sequences[seq_num] do
        {:activity, activity_id} ->
          with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(run_id) do
            WorkflowFlowController.activity_task_resolved(flow_control, activity_id, output)
          end

        found ->
          Logger.error(
            "Expected to resolve activity (Seq: #{seq_num}) but found #{inspect(found)}"
          )

          {:error, "Expected activity but found #{inspect(found)}"}
      end

    {:reply, resp, state}
  end

  def handle_call({:report_completed_success, output}, _from, state) do
    report_successful_completion(state,
      commands: [{:complete_workflow_execution, [result: output]}]
    )
    |> case do
      {:ok, new_state} ->
        send(self(), :stop_workflow)
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        {:reply, {:error, err}, state}
    end
  end

  def handle_cast(:heartbeat, state) do
    if Enum.count(progress_state(state, :command_batch)) > 0 do
      report_successful_completion(state, commands: [])
      |> case do
        {:ok, new_state} ->
          {:noreply, new_state}

        {{:error, err}, _} ->
          Logger.error("Workflow heartbeat error: #{inspect(err)}")
          {:noreply, state}
      end
    else
      {:noreply, state}
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
            sequences: Map.put(sequences, activity[:seq], {:activity, activity[:activity_id]})
          )

        _, state ->
          state
      end)

    completion = Keyword.put(completion, :commands, commands)

    complete_activation_msg =
      WorkflowActivationCompletion.with_opts!(
        run_id: progress_state(state, :run_id),
        status: {:successful, completion}
      )

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_workflow_activation(
          progress_state(state, :runtime).core,
          progress_state(state, :worker).core,
          complete_activation_msg,
          self()
        )
        |> case do
          :ok ->
            receive do
              {:ok, _} ->
                send(parent, {self(), state, :ok})

              {:error, err} ->
                send(parent, {self(), state, {:error, err}})
                Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
            end

          other_resp ->
            send(parent, {self(), state, other_resp})
        end
      end)

    receive do
      {^child, state, resp} ->
        {resp, state}
    end
  end

  def handle_info(:stop_workflow, state) do
    run_id = progress_state(state, :run_id)
    WorkflowSupervisor.stop_workflow(run_id)

    {:noreply, state}
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
