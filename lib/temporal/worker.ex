defmodule Temporal.Worker do
  defstruct [:id, :channel, :task_queue]

  alias Temporal.Activity
  alias Temporal.Comms.Channel
  alias Temporal.Client
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.Internal.Hash
  alias Temporal.TaskQueue
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.WorkerRegistry
  alias Temporal.Workflows.WorkflowName
  alias Temporal.Worker.WorkerWorkflowManager
  alias Temporal.Worker.WorkerActivityManager

  @type t :: %__MODULE__{id: String.t(), task_queue: TaskQueue.t()}
  @type worker_opts :: WorkerOpts.opts() | extra_opts()
  @type extra_opts :: [{:forward_polled_messages, pid()}]
  @type task_queue :: String.t()
  @type activity_type :: String.t()
  @type register_workflow_opts :: [{:name, WorkflowName.t()}]

  @spec new(TaskQueue.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
  def new(task_queue, channel \\ nil, opts \\ []) do
    channel = channel || Channel.new(task_queue)

    initialize_worker(task_queue, channel, opts)
  end

  @spec initialize_worker(TaskQueue.t(), Channel.t(), worker_opts()) ::
          {:ok, t()} | {:error, term()}
  defp initialize_worker(task_queue, channel, opts) do
    opts = task_queue.default_worker_opts ++ opts
    {extra_opts, core_opts} = Keyword.split(opts, [:forward_polled_messages])

    worker_id = Hash.random_hash(8)
    client = task_queue.client

    worker_opts =
      WorkerOpts.with_opts!(
        [
          namespace: client.namespace,
          task_queue: task_queue.queue_name,
          deployment_options: [
            version: [
              build_id: "0.0.1",
              deployment_name: "elixir-sdk-deploy"
            ],
            use_worker_versioning: false,
            default_versioning_behavior: 0
          ],
          max_cached_workflows: 100,
          nonsticky_to_sticky_poll_ratio: 0.5,
          enable_workflows: true,
          enable_local_activities: true,
          enable_remote_activities: true,
          enable_nexus: true,
          sticky_queue_schedule_to_start_timeout_secs: 300.0,
          max_heartbeat_throttle_interval_secs: 60.00,
          default_heartbeat_throttle_interval_secs: 30.0,
          graceful_shutdown_period_secs: 5.0,
          nondeterminism_as_workflow_fail: true,
          tuner: [
            workflow_slot_supplier: {:fixed_size, 10},
            activity_slot_supplier: {:fixed_size, 10},
            local_activity_slot_supplier: {:fixed_size, 10}
          ],
          nondeterminism_as_workflow_fail_for_types: [],
          plugins: [],
          max_worker_activities_per_second: 60,
          max_task_queue_activities_per_second: 60,
          identity_override: nil,
          workflow_task_poller_behavior: {:simple_maximum, [simple_maximum: 5]},
          activity_task_poller_behavior: {:simple_maximum, [simple_maximum: 5]}
        ] ++ core_opts
      )

    with {:ok, core_runtime} <- Client.core_runtime(client),
         {:ok, core_client} <- CoreClient.existing_for_identity(client.identity),
         {:ok, workers_sup} <- ClientSupervisor.workers_sup_for_identity(client.identity) do
      reg_name = {:via, Registry, {WorkerRegistry, {:worker, worker_id}}}

      worker = %__MODULE__{id: worker_id, channel: channel, task_queue: task_queue}

      exec_ctx = %ExecutionContext{
        namespace: client.namespace,
        worker_id: worker_id,
        task_queue: task_queue,
        runtime: core_runtime,
        client: core_client,
        channel: channel,
        worker: worker
      }

      child_started =
        DynamicSupervisor.start_child(
          workers_sup,
          Supervisor.child_spec(
            {WorkerSupervisor,
             {
               exec_ctx,
               extra_opts ++ [config: worker_opts],
               [name: reg_name, shutdown: 3_000]
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
  def register_workflow(worker, workflow_mod, opts \\ []) do
    workflow_name =
      Keyword.get_lazy(opts, :name, fn ->
        WorkflowName.server_recognized_name(workflow_mod)
      end)

    with {:ok, manager_pid} <- WorkerSupervisor.workflow_manager_pid(worker.id) do
      arities_resp = WorkflowName.execution_arities(workflow_mod)

      cond do
        match?({:error, :unknown}, arities_resp) ->
          {:error, "#{inspect(workflow_mod)} is not a module..."}

        match?({:ok, []}, arities_resp) ->
          {:error, "#{inspect(workflow_mod)} does not implement execute/* function..."}

        true ->
          WorkerWorkflowManager.register(manager_pid, workflow_name, workflow_mod)
          register_activities(worker, workflow_mod)

          :ok
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

  def alive_with_id?(worker_id) do
    if pid = GenServer.whereis({:via, Registry, {WorkerRegistry, {:worker, worker_id}}}) do
      Process.alive?(pid)
    else
      false
    end
  end
end
