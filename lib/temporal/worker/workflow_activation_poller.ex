defmodule Temporal.Worker.WorkflowActivationPoller do
  use GenServer

  alias Temporal.CoreSdk
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
    :core_runtime
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
         core_runtime: exec_ctx.runtime
       ), {:continue, :poll_for_activations}}
    end
  end

  @doc false
  def handle_continue(:poll_for_activations, state) do
    with {:ok, state} <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_activations}}
    else
      {{:error, "core_shutdown"}, _} ->
        {:stop, :shutdown, state}

      {{:error, error}, _} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    worker_id = poll_state(state, :worker_id)
    runtime_core = poll_state(state, :core_runtime)
    worker_core = poll_state(state, :core_worker)
    worker_pid = poll_state(state, :worker_pid)
    manager_pid = poll_state(state, :manager_pid)

    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activation_poll, worker_id})

        case CoreSdk._worker_poll_workflow_activation(runtime_core.core, worker_core.core, self()) do
          :ok ->
            receive do
              {:ok, activation} ->
                send(parent, {self(), {:ok, activation}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(
              parent,
              {self(), {:error, "Error polling workflow activations: #{inspect(resp)}"}}
            )
        end
      end)

    poll_resp =
      receive do
        {^child, {:ok, activation}} ->
          WorkerWorkflowManager.process_activation(manager_pid, activation)

        {^child, {:error, err}} ->
          send(worker_pid, {:workflow_activation_error, err})
          {:error, err}
      end

    {poll_resp, state}
  end
end
