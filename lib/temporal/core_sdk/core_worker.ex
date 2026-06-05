defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:core]
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias CoreSdk.Data.WorkflowActivation
  alias CoreSdk.Data.ActivityTask
  alias CoreSdk.Data.NexusTask
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkflowFailure
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus

  require Record

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

  @spec start_link({worker_id(), CoreRuntime.t(), CoreClient.t(), worker_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({worker_id, runtime, client, opts, server_opts}) do
    config = Keyword.fetch!(opts, :config)

    GenServer.start_link(__MODULE__, {worker_id, runtime, client, config, opts}, server_opts)
  end

  @impl true
  @spec init({worker_id(), CoreRuntime.t(), CoreClient.t(), WorkerOpts.t(), worker_opts()}) ::
          {:ok, t()} | {:error, term()}
  def init({worker_id, runtime, client, config, opts}) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_worker(runtime.core, client.core, config, self())
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

    Process.set_label({:worker, worker_id})

    with {:ok, core} <- worker_resp,
         :ok <- validate(core, runtime) do
      {:ok,
       server_state(
         id: worker_id,
         core: core,
         task_queue: config.task_queue,
         namespace: config.namespace,
         identity_override: config.identity_override,
         runtime: runtime,
         client: client,
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
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

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

  @spec poll_workflow_activations(t(), CoreRuntime.t()) ::
          {:ok, WorkflowActivation.t() | nil} | {:error, term()}
  def poll_workflow_activations(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_workflow_activation(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could poll activations from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, activation} ->
            send(parent, {self(), {:ok, activation}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    activations_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case activations_resp do
      {:ok, activation} -> {:ok, activation}
      {:error, err} -> {:error, "Workflow activation poll error: #{inspect(err)}"}
    end
  end

  @spec poll_activity_tasks(t(), CoreRuntime.t()) ::
          {:ok, ActivityTask.t() | nil} | {:error, term()}
  def poll_activity_tasks(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_activity_task(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not poll activity tasks from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    task_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case task_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Activity task poll error: #{inspect(err)}"}
    end
  end

  @spec poll_nexus_tasks(t(), CoreRuntime.t()) :: {:ok, NexusTask.t() | nil} | {:error, term()}
  def poll_nexus_tasks(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_nexus_task(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not poll nexus tasks from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    task_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case task_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Nexus task poll error: #{inspect(err)}"}
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
  def handle_call({:process_workflow_activation, _activation} = msg, _from, state) do
    if forward_to = server_state(state, :forward_polled_pid) do
      send(forward_to, msg)
    end

    {:reply,
     {:ok,
      %WorkflowActivationCompletionFailureStatus{
        force_cause: 0,
        failure: %WorkflowFailure{
          message: "Failed!",
          source: "catch-all",
          stack_trace: inspect(Process.info(self(), :current_stacktrace))
        }
      }}, state}
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
end
