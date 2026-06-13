defmodule Temporal.Worker.ActivityTaskPoller do
  use GenServer

  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Worker.WorkerActivityManager
  alias Temporal.Comms.Channel

  require Logger
  require Record

  Record.defrecordp(:poll_state, [
    :worker_id,
    :activity_manager,
    :channel,
    :worker
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:activity_task_poller, exec_ctx.worker_id})

    with {:ok, activity_manager} <- WorkerSupervisor.activity_manager_pid(exec_ctx.worker_id) do
      {:ok,
       poll_state(
         worker_id: exec_ctx.worker_id,
         activity_manager: activity_manager,
         channel: exec_ctx.channel,
         worker: exec_ctx.worker
       ), {:continue, :poll_for_tasks}}
    end
  end

  @doc false
  def handle_continue(:poll_for_tasks, state) do
    with :ok <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_tasks}}
    else
      {:error, "core_shutdown"} ->
        Logger.debug("Activity Task Poller shutdown triggered...")

        with {:ok, core_pid} <- WorkerSupervisor.core_worker_pid(poll_state(state, :worker_id)) do
          send(core_pid, {:shutdown_complete, :activity_task_poller})
        else
          {:error, err} ->
            Logger.warning(
              "Activity Task Poller failed to notify worker of shutdown #{inspect(err)}"
            )
        end

        {:stop, :shutdown, state}

      {:error, :core_worker_not_online} ->
        Logger.warning(
          "Activity Task Poller was polling after core worker shutdown. Shutting poller down...."
        )

        {:stop, :shutdown, state}

      {:error, error} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    worker = poll_state(state, :worker)
    channel = poll_state(state, :channel)

    case Channel.poll_activity_task(channel, worker) do
      {:ok, nil} -> :ok
      {:ok, task} -> process_activity_task(task, state)
      {:error, err} -> {:error, err}
    end
  end

  defp process_activity_task(nil, _), do: :ok

  defp process_activity_task(task, state) do
    activity_manager = poll_state(state, :activity_manager)

    case WorkerActivityManager.process_task(activity_manager, task) do
      :ok ->
        :ok

      {:error, {:already_started, _}} ->
        :ok

      {:error, err} ->
        Logger.error("Error processing activity task: #{inspect(err)}")
        {:error, err}
    end
  end

  def terminate(reason, state) do
    Logger.debug(
      "Activity Task Poller (#{poll_state(state, :worker_id)}) terminating... #{inspect(reason)}"
    )

    reason
  end
end
