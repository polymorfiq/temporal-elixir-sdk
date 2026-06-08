defmodule Temporal.Supervisor.WorkerSupervisor do
  use Supervisor

  alias Temporal.WorkerRegistry
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.ActivityList
  alias Temporal.Supervisor.WorkflowList
  alias Temporal.TaskQueue
  alias Temporal.Worker.WorkflowActivationPoller
  alias Temporal.Worker.ActivityTaskPoller
  alias Temporal.Worker.NexusTaskPoller
  alias Temporal.Worker.WorkerActivityManager
  alias Temporal.Worker.WorkerWorkflowManager
  alias Temporal.Worker

  @type worker_id :: String.t()

  @spec start_link(
          {worker_id(), TaskQueue.t(), CoreRuntime.t(), CoreClient.t(), Worker.worker_opts(),
           keyword()}
        ) ::
          {:ok, pid()} | {:error, term()}
  def start_link({exec_ctx, opts, server_opts}) do
    Supervisor.start_link(
      __MODULE__,
      {exec_ctx, opts},
      server_opts
    )
  end

  @impl true
  def init({exec_ctx, opts}) do
    worker_id = exec_ctx.worker_id
    Process.set_label({:worker_supervisor, worker_id})

    children = [
      {CoreWorker, {exec_ctx, opts, [name: via_registry({:core, worker_id}), shutdown: 10_000]}},
      {WorkflowList, [name: via_registry({:workflows, worker_id})]},
      {ActivityList, [name: via_registry({:activities, worker_id})]},
      {WorkerWorkflowManager,
       {exec_ctx, opts, [name: via_registry({:workflow_manager, worker_id})]}},
      {WorkerActivityManager, {exec_ctx, [name: via_registry({:activity_manager, worker_id})]}},
      {WorkflowActivationPoller,
       {exec_ctx, [name: via_registry({:workflow_activation_poller, worker_id})]}},
      {ActivityTaskPoller, {exec_ctx, [name: via_registry({:activity_task_poller, worker_id})]}},
      {NexusTaskPoller, {exec_ctx, [name: via_registry({:nexus_operation_poller, worker_id})]}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec worker_pid(worker_id()) :: {:ok, term()} | {:error, term()}
  def worker_pid(worker_id) do
    if pid = GenServer.whereis(via_registry({:core, worker_id})) do
      {:ok, pid}
    else
      {:error, :core_worker_not_running}
    end
  end

  @spec workflow_manager_pid(worker_id()) :: {:ok, term()} | {:error, term()}
  def workflow_manager_pid(worker_id) do
    if pid = GenServer.whereis(via_registry({:workflow_manager, worker_id})) do
      {:ok, pid}
    else
      {:error, :workflow_manager_not_running}
    end
  end

  @spec activity_manager_pid(worker_id()) :: {:ok, term()} | {:error, term()}
  def activity_manager_pid(worker_id) do
    if pid = GenServer.whereis(via_registry({:activity_manager, worker_id})) do
      {:ok, pid}
    else
      {:error, :activity_manager_not_running}
    end
  end

  @spec core_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def core_for_id(worker_id),
    do: CoreWorker.get_core(via_registry({:core, worker_id}))

  @spec runtime_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def runtime_for_id(worker_id),
    do: CoreWorker.get_runtime(via_registry({:core, worker_id}))

  @spec workflows_sup_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def workflows_sup_for_id(worker_id) do
    if pid = GenServer.whereis(via_registry({:workflows, worker_id})) do
      {:ok, pid}
    else
      {:error, "Workflow list not found for worker (#{inspect(worker_id)})"}
    end
  end

  @spec activities_sup_for_id(worker_id()) :: {:ok, term()} | {:error, term()}
  def activities_sup_for_id(worker_id) do
    if pid = GenServer.whereis(via_registry({:activities, worker_id})) do
      {:ok, pid}
    else
      {:error, "Activity list not found for worker (#{inspect(worker_id)})"}
    end
  end

  defp via_registry(name), do: {:via, Registry, {WorkerRegistry, name}}
end
