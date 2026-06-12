defmodule Temporal.Worker.WorkflowActivationPoller do
  use GenServer

  alias Temporal.Comms.Channel
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Worker.WorkerWorkflowManager
  alias Temporal.Supervisor.ExecutionContext

  require Logger
  require Record

  Record.defrecordp(:poll_state, [
    :worker_id,
    :worker_pid,
    :manager_pid,
    :core_worker,
    :core_runtime,
    :channel,
    :worker
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init(ExecutionContext.t()) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.set_label({:workflow_activation_poller, exec_ctx.worker_id})

    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(exec_ctx.worker_id),
         {:ok, manager_pid} <- WorkerSupervisor.workflow_manager_pid(exec_ctx.worker_id),
         {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         worker_pid: worker_pid,
         manager_pid: manager_pid,
         core_worker: worker,
         core_runtime: exec_ctx.runtime,
         channel: exec_ctx.channel,
         worker: exec_ctx.worker
       ), {:continue, :poll_for_activations}}
    end
  end

  @doc false
  def handle_continue(:poll_for_activations, state) do
    with :ok <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_activations}}
    else
      {{:error, "core_shutdown"}, _} ->
        {:stop, :shutdown, state}
    end
  end

  defp poll_and_inform_worker(state) do
    channel = poll_state(state, :channel)
    worker = poll_state(state, :worker)
    manager_pid = poll_state(state, :manager_pid)

    activation = Channel.poll_activation(channel, worker)
    WorkerWorkflowManager.process_activation(manager_pid, activation)
  end
end
