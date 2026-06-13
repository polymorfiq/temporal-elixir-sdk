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
    :manager_pid,
    :channel,
    :worker
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init(ExecutionContext.t()) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:workflow_activation_poller, exec_ctx.worker_id})

    with {:ok, manager_pid} <- WorkerSupervisor.workflow_manager_pid(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         manager_pid: manager_pid,
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
      {:error, "core_shutdown"} ->
        Logger.debug("Workflow Activation Poller shutdown triggered...")

        with {:ok, core_pid} <- WorkerSupervisor.core_worker_pid(poll_state(state, :worker_id)) do
          send(core_pid, {:shutdown_complete, :activation_poller})
        else
          {:error, err} ->
            Logger.warning(
              "Workflow Activation Poller failed to notify worker of shutdown #{inspect(err)}"
            )
        end

        {:stop, :shutdown, state}

      {:error, :core_worker_not_online} ->
        Logger.warning(
          "Worker Activation Poller was polling after core worker shutdown. Shutting poller down...."
        )

        {:stop, :shutdown, state}

      {:error, error} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    channel = poll_state(state, :channel)
    worker = poll_state(state, :worker)
    manager_pid = poll_state(state, :manager_pid)

    case Channel.poll_activation(channel, worker) do
      {:ok, nil} -> :ok
      {:ok, activation} -> WorkerWorkflowManager.process_activation(manager_pid, activation)
      {:error, err} -> {:error, err}
    end
  end

  def terminate(reason, state) do
    Logger.debug(
      "Workflow Activation Poller (#{poll_state(state, :worker_id)}) terminating... #{inspect(reason)}"
    )

    reason
  end
end
