defmodule Temporal.Worker.NexusTaskPoller do
  use GenServer

  alias Temporal.Comms.Channel
  alias Temporal.Supervisor.WorkerSupervisor

  require Logger
  require Record
  Record.defrecordp(:poll_state, [:worker_id, :worker, :channel])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:nexus_task_poller, exec_ctx.worker_id})

    {:ok,
     poll_state(
       worker_id: exec_ctx.worker_id,
       worker: exec_ctx.worker,
       channel: exec_ctx.channel
     ), {:continue, :poll_for_tasks}}
  end

  @doc false
  def handle_continue(:poll_for_tasks, state) do
    with :ok <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_tasks}}
    else
      {:error, "core_shutdown"} ->
        Logger.debug("Nexus Task Poller shutdown triggered...")

        with {:ok, core_pid} <- WorkerSupervisor.core_worker_pid(poll_state(state, :worker_id)) do
          send(core_pid, {:shutdown_complete, :nexus_task_poller})
        else
          {:error, err} ->
            Logger.warning(
              "Nexus Task Poller failed to notify worker of shutdown #{inspect(err)}"
            )
        end

        {:stop, :shutdown, state}

      {:error, :core_worker_not_online} ->
        Logger.warning(
          "Nexus Task Poller was polling after core worker shutdown. Shutting poller down...."
        )

        {:stop, :shutdown, state}

      {:error, error} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    worker = poll_state(state, :worker)
    channel = poll_state(state, :channel)

    case Channel.poll_nexus_task(channel, worker) do
      {:ok, nil} -> :ok
      {:ok, task} -> process_nexus_task(task, state)
      {:error, err} -> {:error, err}
    end
  end

  defp process_nexus_task(_task, _) do
    :ok
  end

  def terminate(reason, state) do
    Logger.debug(
      "Nexus Task Poller (#{poll_state(state, :worker_id)}) terminating... #{inspect(reason)}"
    )

    reason
  end
end
