defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:core]
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Worker.WorkerWorkflowManager

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
    forward_polled_pid: nil
  ])

  @type worker_id :: String.t()
  @type t :: %__MODULE__{
          core: term()
        }

  @type worker_opts :: [{:config, WorkerOpts.t()} | {:forward_polled_messages, pid()}]

  @spec start_link({ExecutionContext.t(), worker_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({exec_ctx, opts, server_opts}) do
    config = Keyword.fetch!(opts, :config)

    GenServer.start_link(__MODULE__, {exec_ctx, config, opts}, server_opts)
  end

  @impl true
  @spec init({ExecutionContext.t(), WorkerOpts.t(), worker_opts()}) ::
          {:ok, t()} | {:error, term()}
  def init({exec_ctx, config, opts}) do
    Process.flag(:trap_exit, true)
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_worker(exec_ctx.runtime.core, exec_ctx.client.core, config, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize worker from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, worker} ->
            send(parent, {self(), {:ok, worker}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    worker_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    Process.set_label({:worker, exec_ctx.worker_id})

    with {:ok, core} <- worker_resp, :ok <- validate(core, exec_ctx.runtime) do
      {:ok,
       server_state(
         id: exec_ctx.worker_id,
         core: core,
         task_queue: config.task_queue,
         namespace: exec_ctx.namespace,
         identity_override: config.identity_override,
         runtime: exec_ctx.runtime,
         client: exec_ctx.client,
         forward_polled_pid: Keyword.get(opts, :forward_polled_messages)
       )}
    end
  end

  @spec validate(worker_ref :: term(), CoreRuntime.t()) :: :ok | {:error, term()}
  def validate(worker_ref, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._validate_worker(runtime.core, worker_ref, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not validate worker via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, resp} ->
            send(parent, {self(), {:ok, resp}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    validate_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case validate_resp do
      {:ok, true} -> :ok
      {:error, err} -> {:error, "Validation error: #{inspect(err)}"}
    end
  end

  def get_core(pid), do: GenServer.call(pid, :get_core)
  def get_runtime(pid), do: GenServer.call(pid, :get_runtime)

  def process_workflow_activation(pid, activation) do
    GenServer.call(pid, {:process_workflow_activation, activation}, :infinity)
  end

  def process_activity_task(pid, task) do
    GenServer.call(pid, {:process_activity_task, task}, :infinity)
  end

  def process_nexus_task(pid, task) do
    GenServer.call(pid, {:process_nexus_task, task}, :infinity)
  end

  @impl true
  def handle_call({:process_workflow_activation, activation}, _from, state) do
    if forward_to = server_state(state, :forward_polled_pid) do
      Enum.each(activation.jobs, fn job ->
        send(forward_to, {:workflow_activation_job, job.variant, activation})
      end)
    end

    process_activation(activation, state)

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:process_activity_task, _task} = msg, _from, state) do
    if forward_to = server_state(state, :forward_polled_pid) do
      send(forward_to, msg)
    end

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:process_nexus_task, _task} = msg, _from, state) do
    if forward_to = server_state(state, :forward_polled_pid) do
      send(forward_to, msg)
    end

    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:get_core, _from, state),
    do: {:reply, {:ok, %__MODULE__{core: server_state(state, :core)}}, state}

  @impl true
  def handle_call(:get_runtime, _from, state),
    do: {:reply, {:ok, server_state(state, :runtime)}, state}

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state),
    do: {:noreply, state}

  defp process_activation(activation, state) do
    worker_id = server_state(state, :id)
    workflow_manager_pid = WorkerSupervisor.workflow_manager_pid(worker_id)
    WorkerWorkflowManager.process_activation(workflow_manager_pid, activation)
  end

  @impl true
  def terminate(reason, state) do
    Logger.debug("Worker (#{friendly_name(state)}) terminating: #{inspect(reason)}")

    with :ok <- initiate_shutdown(state),
         :ok <- finalize_shutdown(state) do
      :shutdown
    end
  end

  defp initiate_shutdown(state) do
    worker_core = server_state(state, :core)

    parent = self()

    child =
      spawn_link(fn ->
        case CoreSdk._worker_initiate_shutdown(worker_core, self()) do
          :ok ->
            receive do
              {:ok, success} ->
                Logger.debug("Worker (#{friendly_name(state)}) shutdown initiated.")
                send(parent, {self(), {:ok, success}})

              {:error, error} ->
                Logger.debug(
                  "Worker (#{friendly_name(state)}) shutdown initiation errored (#{inspect(error)})."
                )

                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error initiating shutdown: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, _}} ->
        :ok

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  defp finalize_shutdown(state) do
    worker_core = server_state(state, :core)

    parent = self()

    child =
      spawn_link(fn ->
        Logger.debug("Worker (#{friendly_name(state)}) finalizing shutdown...")

        case CoreSdk._worker_finalize_shutdown(worker_core, self()) do
          :ok ->
            receive do
              {:ok, success} ->
                Logger.debug("Worker (#{friendly_name(state)}) shutdown finalized.")
                send(parent, {self(), {:ok, success}})

              {:error, error} ->
                Logger.debug(
                  "Worker (#{friendly_name(state)}) shutdown finalization errored (#{inspect(error)})."
                )

                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error finalizing shutdown: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, _}} ->
        :ok

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  defp friendly_name(state), do: server_state(state, :id)
end
