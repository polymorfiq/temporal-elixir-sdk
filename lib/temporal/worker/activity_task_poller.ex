defmodule Temporal.Worker.ActivityTaskPoller do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Worker.WorkerActivityManager

  require Logger
  require Record

  Record.defrecordp(:poll_state, [
    :worker_id,
    :worker_pid,
    :activity_manager,
    :core_worker,
    :core_runtime
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(exec_ctx.worker_id),
         {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id),
         {:ok, activity_manager} <- WorkerSupervisor.activity_manager_pid(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         worker_pid: worker_pid,
         activity_manager: activity_manager,
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
          process_activity_task(task, state)

        {^child, {:error, err}} ->
          send(worker_pid, {:activity_task_error, err})
          {:error, err}
      end

    {poll_resp, state}
  end

  defp process_activity_task(task, state) do
    activity_manager = poll_state(state, :activity_manager)

    case WorkerActivityManager.process_task(activity_manager, task) do
      :ok ->
        :ok

      {:error, {:already_started, _}} ->
        :ok

      {:error, err} ->
        Logger.error("Error processing activity task: #{inspect(err)}")
    end

    {:ok, task}
  end
end
