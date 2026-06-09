defmodule Temporal.Activity.ActivityProgressReporter do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.ActivityTaskCompletion
  alias Temporal.CoreSdk.Data.WorkflowInput
  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.Supervisor.ActivitySupervisor

  require Logger
  require Record

  Record.defrecordp(:progress_state, [
    :activity_id,
    :task_token,
    :runtime,
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
       worker: exec_ctx.worker
     )}
  end

  @spec report_success(pid, term()) :: :ok | {:error, term()}
  def report_success(pid, result),
    do: GenServer.call(pid, {:report_success, result}, :infinity)

  def handle_call({:report_success, result}, _from, state) do
    task_token = progress_state(state, :task_token)

    output = WorkflowInput.with_opts!(result) |> Payload.from_workflow_input()

    completion =
      ActivityTaskCompletion.with_opts!(
        task_token: task_token,
        result: {:completed, [result: output]}
      )

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_activity_task(
          progress_state(state, :runtime).core,
          progress_state(state, :worker).core,
          completion,
          self()
        )
        |> case do
          :ok ->
            send(parent, {self(), :ok})

          other_resp ->
            send(parent, {self(), other_resp})
        end

        receive do
          :ok ->
            :ok

          {:error, err} ->
            Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
        end
      end)

    receive do
      {^child, resp} ->
        {:reply, resp, state, {:continue, :stop_activity}}
    end
  end

  def handle_continue(:stop_activity, state) do
    activity_id = progress_state(state, :activity_id)
    ActivitySupervisor.stop_activity(activity_id)

    {:noreply, state}
  end
end
