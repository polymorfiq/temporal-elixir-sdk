defmodule Temporal.Activity.ActivityProgressReporter do
  use GenServer

  alias Temporal.Comms.Channel
  alias Temporal.Supervisor.ActivitySupervisor

  require Logger
  require Record

  Record.defrecordp(:progress_state, [
    :activity_id,
    :task_token,
    :runtime,
    :channel,
    :worker
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
       activity_id: exec_ctx.activity_id,
       task_token: exec_ctx.activity_task_token,
       runtime: exec_ctx.runtime,
       channel: exec_ctx.channel,
       worker: exec_ctx.worker
     )}
  end

  @spec report_success(pid, term()) :: :ok | {:error, term()}
  def report_success(pid, result),
    do: GenServer.call(pid, {:report_success, result}, :infinity)

  def handle_call({:report_success, result}, _from, state) do
    task_token = progress_state(state, :task_token)
    worker = progress_state(state, :worker)

    channel = progress_state(state, :channel)
    resp = Channel.send_to_engine(channel, worker, {:activity, :completed, result, task_token})
    {:reply, resp, state, {:continue, :stop_activity}}
  end

  def handle_continue(:stop_activity, state) do
    activity_id = progress_state(state, :activity_id)
    ActivitySupervisor.stop_activity(activity_id)

    {:noreply, state}
  end
end
