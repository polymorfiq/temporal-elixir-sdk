defmodule Temporal.Worker.ActivityTaskPoller do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.WorkerSupervisor

  require Record
  Record.defrecordp(:poll_state, [:worker_id, :worker_pid, :core_worker, :core_runtime])

  def start_link({worker_id, server_opts}) do
    GenServer.start_link(__MODULE__, worker_id, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(worker_id) do
    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(worker_id),
         {:ok, core_worker} <- CoreWorker.get_core(worker_pid),
         {:ok, core_runtime} <- CoreWorker.get_runtime(worker_pid) do
      {:ok,
       poll_state(
         worker_id: worker_id,
         worker_pid: worker_pid,
         core_worker: core_worker,
         core_runtime: core_runtime
       ), {:continue, :poll_for_tasks}}
    end
  end

  @doc false
  def handle_continue(:poll_for_tasks, state) do
    with {{:ok, _}, state} <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_tasks}}
    else
      {{:error, error}, _} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    runtime_core = poll_state(state, :core_runtime)
    worker_core = poll_state(state, :core_worker)
    worker_pid = poll_state(state, :worker_pid)

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_poll_activity_task(runtime_core.core, worker_core.core, self())
        |> case do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling activity tasks: #{inspect(resp)}"}})
        end
      end)

    poll_resp =
      receive do
        {^child, {:ok, task}} ->
          CoreWorker.process_activity_task(worker_pid, task)
          {:ok, task}

        {^child, {:error, err}} ->
          send(worker_pid, {:activity_task_error, err})
          {:error, err}
      end

    {poll_resp, state}
  end
end
