defmodule Temporal.Worker do
  defstruct [:id, :task_queue]

  import TemporalEngine.Config

  alias TemporalEngine.Config
  alias Temporal.Activity
  alias Temporal.Client
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.Internal.Hash
  alias Temporal.TaskQueue
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.WorkerRegistry
  alias Temporal.Workflows.WorkflowName
  alias Temporal.Worker.WorkerWorkflowManager
  alias Temporal.Worker.WorkerActivityManager

  @type t :: %__MODULE__{id: String.t(), task_queue: TaskQueue.t()}

  @type task_queue :: String.t()
  @type activity_type :: String.t()
  @type register_workflow_opts :: [{:name, WorkflowName.t()}]

  @spec new(TaskQueue.t(), Config.worker_config()) :: {:ok, t()} | {:error, term()}
  def new(task_queue, opts \\ []) do
    opts = Keyword.put(opts, :task_queue, task_queue.queue_name)
    opts = Keyword.put_new(opts, :namespace, task_queue.client.namespace)

    initialize_worker(task_queue, opts)
  end

  @spec initialize_worker(TaskQueue.t(), Config.worker_config()) :: {:ok, t()} | {:error, term()}
  defp initialize_worker(task_queue, opts) do
    worker_id = Hash.random_hash(8)
    client = task_queue.client

    with {:ok, core_runtime} <- Client.core_runtime(client),
         {:ok, core_client} <- CoreClient.existing_for_identity(client.identity),
         {:ok, workers_sup} <- ClientSupervisor.workers_sup_for_identity(client.identity) do
      reg_name = {:via, Registry, {WorkerRegistry, {:worker, worker_id}}}

      worker = %__MODULE__{id: worker_id, task_queue: task_queue}

      exec_ctx = %ExecutionContext{
        namespace: opts[:namespace],
        worker_id: worker_id,
        task_queue: task_queue,
        runtime: core_runtime,
        client: core_client,
        worker: worker
      }

      child_started =
        DynamicSupervisor.start_child(
          workers_sup,
          Supervisor.child_spec(
            {WorkerSupervisor,
             {
               exec_ctx,
               worker_config_from_opts!(opts ++ [id: worker_id]),
               [name: reg_name, shutdown: 60_000]
             }},
            restart: :transient
          )
        )

      with {:ok, _} <- child_started do
        {:ok, worker}
      end
    end
  end

  @spec stop_with_id(worker_id :: String.t()) :: :ok | {:error, term()}
  def stop_with_id(worker_id) do
    if sup = GenServer.whereis({:via, Registry, {WorkerRegistry, {:worker, worker_id}}}) do
      Supervisor.stop(sup, :shutdown, :infinity)
    else
      {:error, :worker_already_stopped}
    end
  end

  @spec shutdown(t()) :: :ok | {:error, term()}
  def shutdown(worker) do
    if core_worker = GenServer.whereis({:via, Registry, {WorkerRegistry, {:core, worker.id}}}) do
      CoreWorker.shutdown(core_worker)
    else
      {:error, :core_worker_already_shutdown}
    end
  end

  @spec register_workflow(t(), WorkflowName.t(), register_workflow_opts()) ::
          :ok | {:error, term()}

  def register_workflow(_worker, _workflow_name, _opts \\ [])

  def register_workflow(worker, {workflow_mod, execute_fns}, opts) when is_list(execute_fns) do
    execute_fns
    |> Enum.each(fn
      {execute_fn_name, curr_opts} when is_atom(execute_fn_name) ->
        register_workflow(
          worker,
          workflow_mod,
          opts ++ curr_opts ++ [execute_fn: execute_fn_name]
        )

      execute_fn_name when is_atom(execute_fn_name) ->
        register_workflow(worker, workflow_mod, execute_fn: execute_fn_name)
    end)
  end

  def register_workflow(worker, workflow_mod, opts) do
    with {:module, _} <- Code.ensure_loaded(workflow_mod) do
      execute_fn = opts[:execute_fn] || :execute

      workflow_name =
        Keyword.get_lazy(opts, :name, fn ->
          WorkflowName.server_recognized_name({workflow_mod, execute_fn})
        end)

      with {:ok, manager_pid} <- WorkerSupervisor.workflow_manager_pid(worker.id) do
        arities_resp = WorkflowName.execution_arities({workflow_mod, execute_fn})

        cond do
          match?({:error, :unknown}, arities_resp) ->
            {:error, "#{inspect(workflow_mod)} is not a module..."}

          match?({:ok, []}, arities_resp) ->
            {:error, "#{inspect(workflow_mod)} does not implement execute/* function..."}

          true ->
            WorkerWorkflowManager.register(manager_pid, workflow_name, workflow_mod, execute_fn)
            register_activities(worker, workflow_mod)

            :ok
        end
      end
    end
  end

  @spec register_activities(t(), module()) :: :ok | {:error, term()}
  def register_activities(worker, mod) do
    if function_exported?(mod, :_temporal_activities, 0) do
      Enum.each(mod._temporal_activities(), fn
        {fn_name, arity} when is_atom(fn_name) and is_integer(arity) ->
          activity_fn = Function.capture(mod, fn_name, arity)
          register_activity(worker, activity_fn)

        {fn_name, arity, opts}
        when is_atom(fn_name) and is_integer(arity) and is_list(opts) ->
          activity_fn = Function.capture(mod, fn_name, arity)
          register_activity(worker, activity_fn, opts)
      end)
    end
  end

  @spec register_activity(t(), activity :: function(), keyword()) :: :ok | {:error, term()}
  def register_activity(worker, activity_fn, opts \\ []) do
    activity_type =
      Keyword.get_lazy(opts, :name, fn ->
        Activity.name_for_type(activity_fn)
      end)

    with {:ok, manager_pid} <- WorkerSupervisor.activity_manager_pid(worker.id) do
      WorkerActivityManager.register(manager_pid, activity_type, activity_fn)
    end
  end

  def worker_supervisor_pid(worker_id) do
    if pid = GenServer.whereis({:via, Registry, {WorkerRegistry, {:worker, worker_id}}}) do
      pid
    else
      nil
    end
  end
end
