defmodule Temporal.Worker.ActivityTaskPoller do
  use GenServer

  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Worker.WorkerActivityManager
  alias Temporal.Comms.Channel

  require Logger
  require Record

  Record.defrecordp(:poll_state, [
    :worker_id,
    :worker_pid,
    :activity_manager,
    :core_worker,
    :core_runtime,
    :channel,
    :worker
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.set_label({:activity_task_poller, exec_ctx.worker_id})

    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(exec_ctx.worker_id),
         {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id),
         {:ok, activity_manager} <- WorkerSupervisor.activity_manager_pid(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         worker_pid: worker_pid,
         activity_manager: activity_manager,
         core_worker: worker,
         core_runtime: exec_ctx.runtime,
         channel: exec_ctx.channel,
         worker: exec_ctx.worker
       ), {:continue, :poll_for_tasks}}
    end
  end

  @doc false
  def handle_continue(:poll_for_tasks, state) do
    with {:ok, _} <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_tasks}}
    else
      {{:error, "core_shutdown"}, _} ->
        Logger.debug("Activity Task Poller shutdown triggered...")
        {:stop, :shutdown, state}

      {{:error, error}, _} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    worker = poll_state(state, :worker)
    channel = poll_state(state, :channel)

    Channel.poll_activity_task(channel, worker) |> process_activity_task(state)
  end

  defp process_activity_task(nil, _), do: {:ok, nil}

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
