defmodule Temporal.Activity.ActivityProgressReporter do
  use GenServer

  require Logger
  require Record

  import TemporalEngine.Data.ActivityTaskCompletion
  import TemporalEngine.Data.Failure

  alias Temporal.Supervisor.ActivitySupervisor
  alias TemporalEngine.Data.Payload

  Record.defrecordp(:progress_state, [
    :run_id,
    :activity_id,
    :task_token,
    :runtime,
    :core_worker
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
    Process.set_label({:activity_progress_reporter, exec_ctx.activity_id})

    {:ok,
     progress_state(
       run_id: exec_ctx.run_id,
       activity_id: exec_ctx.activity_id,
       task_token: exec_ctx.activity_task_token,
       runtime: exec_ctx.runtime,
       core_worker: exec_ctx.core_worker
     )}
  end

  @spec report_success(pid, term()) :: :ok | {:error, term()}
  def report_success(pid, result),
    do: GenServer.call(pid, {:report_success, Payload.record_from_value(result)}, :infinity)

  @spec report_failure(pid, term()) :: :ok | {:error, term()}
  def report_failure(pid, result),
    do: GenServer.call(pid, {:report_failure, Payload.record_from_value(result)}, :infinity)

  def handle_call({:report_success, result}, _from, state) do
    task_token = progress_state(state, :task_token)
    core_worker = progress_state(state, :core_worker)

    resp =
      TemporalEngine.Worker.complete_activity_task(
        core_worker.core,
        task_token,
        activity_completed(result: result)
      )

    {:reply, resp, state, {:continue, :stop_activity}}
  end

  def handle_call({:report_failure, err}, _from, state) do
    task_token = progress_state(state, :task_token)
    core_worker = progress_state(state, :core_worker)

    resp =
      TemporalEngine.Worker.complete_activity_task(
        core_worker.core,
        task_token,
        activity_failed(failure: failure(message: "#{inspect(err)}"))
      )

    {:reply, resp, state, {:continue, :stop_activity}}
  end

  def handle_continue(:stop_activity, state) do
    run_id = progress_state(state, :run_id)
    activity_id = progress_state(state, :activity_id)
    ActivitySupervisor.stop_activity(run_id, activity_id)

    {:noreply, state}
  end
end
