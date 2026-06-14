defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:core]
  use GenServer

  import TemporalEngine.Client

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Worker

  require Record
  require Logger

  Record.defrecordp(:server_state, [
    :id,
    :namespace,
    :task_queue,
    :identity_override,
    :runtime,
    :client,
    :core,
    shutdowns: %{},
    waiting_on_shutdown: []
  ])

  @type worker_id :: String.t()
  @type t :: %__MODULE__{
          core: term()
        }

  @type worker_opts :: [{:config, WorkerOpts.t()} | {:forward_polled_messages, pid()}]

  @worker_store Temporal.Application.worker_store()

  @spec start_link({ExecutionContext.t(), worker_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({exec_ctx, opts, server_opts}) do
    config = Keyword.fetch!(opts, :config)

    GenServer.start_link(__MODULE__, {exec_ctx, config, opts}, server_opts)
  end

  @impl true
  @spec init({ExecutionContext.t(), WorkerOpts.t(), worker_opts()}) ::
          {:ok, t()} | {:error, term()}
  def init({exec_ctx, config, _opts}) do
    Process.set_label({:worker, exec_ctx.worker_id})

    try do
      :ets.new(@worker_store, [:set, :public, :named_table, read_concurrency: true])
    rescue
      ArgumentError ->
        # Table already exists
        :ok
    end

    existing_core_worker =
      case :ets.lookup(@worker_store, {:core, exec_ctx.worker_id}) do
        [{_, core}] -> core
        _ -> nil
      end

    worker_resp =
      if existing_core_worker do
        {:ok, existing_core_worker}
      else
        TemporalEngine.Client.create_worker(exec_ctx.client.core, config)
      end

    with {:ok, core} <- worker_resp do
      :ets.insert(@worker_store, {{:core, exec_ctx.worker_id}, core})
      :ets.insert(@worker_store, {{:runtime, exec_ctx.worker_id}, exec_ctx.runtime})

      {:ok,
       server_state(
         id: exec_ctx.worker_id,
         core: core,
         task_queue: worker_opts(config, :task_queue),
         namespace: exec_ctx.namespace,
         identity_override: worker_opts(config, :identity_override),
         runtime: exec_ctx.runtime,
         client: exec_ctx.client
       )}
    end
  end

  def existing_for_id(worker_id) do
    case :ets.lookup(@worker_store, {:core, worker_id}) do
      [{_, core}] ->
        {:ok, %__MODULE__{core: core}}

      _ ->
        {:error, :core_worker_not_online}
    end
  end

  def runtime_for_id(worker_id) do
    case :ets.lookup(@worker_store, {:runtime, worker_id}) do
      [{_, core}] ->
        {:ok, %CoreRuntime{core: core}}

      _ ->
        {:error, :core_worker_runtime_not_online}
    end
  end

  def shutdown(pid), do: GenServer.call(pid, :shutdown, :infinity)

  def process_activity_task(pid, task) do
    GenServer.call(pid, {:process_activity_task, task}, :infinity)
  end

  def process_nexus_task(pid, task) do
    GenServer.call(pid, {:process_nexus_task, task}, :infinity)
  end

  @impl true
  def handle_call({:process_activity_task, _task}, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:process_nexus_task, _task}, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:shutdown, from, state) do
    Logger.debug("Worker (#{friendly_name(state)}) shutting down...")

    with :ok <- initiate_shutdown(state) do
      waiting = server_state(state, :waiting_on_shutdown)
      waiting = [from | waiting]

      {:noreply, server_state(state, waiting_on_shutdown: waiting)}
    else
      {:error, err} ->
        {:reply, {:error, err}, state}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state),
    do: {:noreply, state}

  def handle_info({:shutdown_complete, poller}, state) do
    shutdowns = server_state(state, :shutdowns)
    shutdowns = Map.put(shutdowns, poller, true)
    state = server_state(state, shutdowns: shutdowns)

    if shutdowns[:activity_task_poller] && shutdowns[:nexus_task_poller] &&
         shutdowns[:activation_poller] do
      Logger.debug(
        "Worker (#{friendly_name(state)}) received all shutdown verifications. Finalizing..."
      )

      :ets.delete(@worker_store, {:core, server_state(state, :id)})
      :ets.delete(@worker_store, {:runtime, server_state(state, :id)})

      with :ok <- finalize_shutdown(state) do
        server_state(state, :waiting_on_shutdown)
        |> Enum.each(&GenServer.reply(&1, :ok))

        Logger.debug("Worker (#{friendly_name(state)}) finalized shutdown!")

        spawn(fn ->
          Worker.stop_with_id(server_state(state, :id))
        end)

        {:stop, :shutdown, state}
      else
        err ->
          server_state(state, :waiting_on_shutdown)
          |> Enum.each(&GenServer.reply(&1, {:error, err}))

          Logger.error(
            "Worker (#{friendly_name(state)}) failed to finalize shutdown... Still proceeding. #{inspect(err)}"
          )

          {:stop, :shutdown, state}
      end
    else
      {:noreply, state}
    end
  end

  defp initiate_shutdown(state) do
    worker_core = server_state(state, :core)

    with :ok <- TemporalEngine.Worker.initiate_shutdown(worker_core) do
      Logger.debug("Worker (#{friendly_name(state)}) shutdown initiated.")
      :ok
    else
      {:error, err} ->
        Logger.error(
          "Worker (#{friendly_name(state)}) shutdown initiation errored (#{inspect(err)})."
        )

        {:error, err}
    end
  end

  defp finalize_shutdown(state) do
    worker_core = server_state(state, :core)
    TemporalEngine.Worker.finalize_shutdown(worker_core)
  end

  defp friendly_name(state), do: server_state(state, :id)
end
