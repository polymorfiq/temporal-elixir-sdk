defmodule Temporal.Worker.NexusTaskPoller do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.WorkerSupervisor

  require Record
  Record.defrecordp(:poll_state, [:worker_id, :worker_pid, :core_worker, :core_runtime])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.set_label({:nexus_task_poller, exec_ctx.worker_id})

    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(exec_ctx.worker_id),
         {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         worker_pid: worker_pid,
         core_worker: worker,
         core_runtime: exec_ctx.runtime
       ), {:continue, :poll_for_tasks}}
    end
  end

  @doc false
  def handle_continue(:poll_for_tasks, state) do
    with {{:ok, _}, state} <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_tasks}}
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

    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_nexus_poll, worker_id})

        case CoreSdk._worker_poll_nexus_task(runtime_core.core, worker_core.core, self()) do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling nexus tasks: #{inspect(resp)}"}})
        end
      end)

    poll_resp =
      receive do
        {^child, {:ok, task}} ->
          CoreWorker.process_nexus_task(worker_pid, task)
          {:ok, task}

        {^child, {:error, err}} ->
          send(worker_pid, {:nexus_task_error, err})
          {:error, err}
      end

    {poll_resp, state}
  end
end
