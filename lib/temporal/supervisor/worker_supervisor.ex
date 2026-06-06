defmodule Temporal.Supervisor.WorkerSupervisor do
  use Supervisor

  alias Temporal.WorkerRegistry
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.Worker.WorkflowActivationPoller
  alias Temporal.Worker.ActivityTaskPoller
  alias Temporal.Worker.NexusTaskPoller

  @type worker_id :: String.t()

  @spec start_link({worker_id(), CoreRuntime.t(), CoreClient.t(), WorkerOpts.t(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({worker_id, runtime_core, client_core, opts, server_opts}) do
    Supervisor.start_link(__MODULE__, {worker_id, runtime_core, client_core, opts}, server_opts)
  end

  @impl true
  def init({worker_id, runtime_core, client_core, opts}) do
    children = [
      {CoreWorker,
       {worker_id, runtime_core, client_core, opts,
        [name: via_registry({:core, worker_id}), shutdown: 10_000]}},
      {WorkflowActivationPoller,
       {worker_id, [name: via_registry({:workflow_activation_poller, worker_id})]}},
      {ActivityTaskPoller, {worker_id, [name: via_registry({:activity_task_poller, worker_id})]}},
      {NexusTaskPoller, {worker_id, [name: via_registry({:nexus_operation_poller, worker_id})]}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec worker_pid(worker_id()) :: {:ok, term()} | {:error, term()}
  def worker_pid(worker_id), do: {:ok, via_registry({:core, worker_id})}

  @spec core_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def core_for_id(worker_id),
    do: CoreWorker.get_core(via_registry({:core, worker_id}))

  @spec runtime_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def runtime_for_id(worker_id),
    do: CoreWorker.get_runtime(via_registry({:core, worker_id}))

  defp via_registry(name), do: {:via, Registry, {WorkerRegistry, name}}
end
