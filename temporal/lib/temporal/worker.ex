defmodule Temporal.Worker do
  defstruct [:id, :task_queue]

  import TemporalEngine.Client

  alias TemporalEngine.Data.Duration
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

  @supplier_schema {:or,
                    [
                      {:non_empty_keyword_list,
                       [fixed_size: [required: true, type: :pos_integer]]},
                      {:non_empty_keyword_list,
                       [
                         target_mem_usage: [required: true, type: :float],
                         target_cpu_usage: [required: true, type: :float],
                         min_slots: [required: true, type: :pos_integer],
                         max_slots: [required: true, type: :pos_integer],
                         ramp_throttle: [required: true, type: :float]
                       ]}
                    ]}

  @tuner_schema [
    workflow_slot_supplier: [required: true, type: @supplier_schema],
    activity_slot_supplier: [required: true, type: @supplier_schema],
    local_activity_slot_supplier: [required: true, type: @supplier_schema]
  ]

  @poller_schema {:or,
                  [
                    {:non_empty_keyword_list,
                     [
                       minimum: [required: true, type: :pos_integer],
                       maximum: [required: true, type: :pos_integer],
                       initial: [required: true, type: :pos_integer]
                     ]},
                    {:non_empty_keyword_list,
                     [
                       simple_maximum: [required: true, type: :pos_integer]
                     ]}
                  ]}

  @opts_schema NimbleOptions.new!(
                 namespace: [
                   required: true,
                   type: :string,
                   doc: "The Temporal service namespace this worker is bound to"
                 ],
                 task_queue: [
                   required: true,
                   type: :string,
                   doc:
                     "What task queue will this worker poll from? This task queue name will be used for both workflow and activity polling."
                 ],
                 client_identity_override: [
                   required: false,
                   type: :string,
                   doc:
                     "A human-readable string that can identify this worker. Using something like sdk version and host name is a good default. If set, overrides the identity set (if any) on the client used by this worker."
                 ],
                 max_cached_workflows: [
                   required: true,
                   type: :pos_integer,
                   doc:
                     "If set nonzero, workflows will be cached and sticky task queues will be used, meaning that history updates are applied incrementally to suspended instances of workflow execution. Workflows are evicted according to a least-recently-used policy once the cache maximum is reached. Workflows may also be explicitly evicted at any time, or as a result of errors or failures."
                 ],
                 tuner: [
                   required: true,
                   doc:
                     "Set a [WorkerTuner](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/trait.WorkerTuner.html) for this worker. Either this or at least one of the max_outstanding_* fields must be set",
                   type: :non_empty_keyword_list,
                   keys: @tuner_schema
                 ],
                 workflow_task_poller_behavior: [
                   default: [simple_maximum: 5],
                   type: @poller_schema,
                   doc:
                     "Maximum number of concurrent poll workflow task requests we will perform at a time on this worker’s task queue. See also [WorkerConfig::nonsticky_to_sticky_poll_ratio](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/struct.WorkerConfig.html#structfield.nonsticky_to_sticky_poll_ratio). If using SimpleMaximum, Must be at least 2 when max_cached_workflows > 0, or is an error."
                 ],
                 nonsticky_to_sticky_poll_ratio: [
                   default: 0.2,
                   type: :float,
                   doc:
                     "Only applies when using [PollerBehavior::SimpleMaximum](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/enum.PollerBehavior.html#variant.SimpleMaximum)

                     (max workflow task polls * this number) = the number of max pollers that will be allowed for the nonsticky queue when sticky tasks are enabled. If both defaults are used, the sticky queue will allow 4 max pollers while the nonsticky queue will allow one. The minimum for either poller is 1, so if the maximum allowed is 1 and sticky queues are enabled, there will be 2 concurrent polls."
                 ],
                 activity_task_poller_behavior: [
                   default: [simple_maximum: 5],
                   type: @poller_schema,
                   doc:
                     "Maximum number of concurrent poll activity task requests we will perform at a time on this worker’s task queue"
                 ],
                 nexus_task_poller_behavior: [
                   default: [simple_maximum: 5],
                   type: @poller_schema,
                   doc:
                     "Maximum number of concurrent poll nexus task requests we will perform at a time on this worker’s task queue"
                 ],
                 task_types: [
                   required: true,
                   type: :non_empty_keyword_list,
                   doc:
                     "Specifies which task types this worker will poll for.

                      Note: At least one task type must be specified or the worker will fail validation.",
                   keys: [
                     enable_workflows: [default: false, type: :boolean],
                     enable_local_activities: [default: false, type: :boolean],
                     enable_remote_activities: [default: false, type: :boolean],
                     enable_nexus: [default: false, type: :boolean]
                   ]
                 ],
                 sticky_queue_schedule_to_start_timeout: [
                   default: {10, :seconds},
                   type: {:tuple, [:pos_integer, {:in, [:seconds, :milliseconds]}]},
                   type_doc:
                     "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)",
                   doc:
                     "How long a workflow task is allowed to sit on the sticky queue before it is timed out and moved to the non-sticky queue where it may be picked up by any worker."
                 ],
                 max_heartbeat_throttle_interval: [
                   default: {60, :seconds},
                   type: {:tuple, [:pos_integer, {:in, [:seconds, :milliseconds]}]},
                   type_doc:
                     "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)",
                   doc: "Longest interval for throttling activity heartbeats"
                 ],
                 default_heartbeat_throttle_interval: [
                   default: {30, :seconds},
                   type: {:tuple, [:pos_integer, {:in, [:seconds, :milliseconds]}]},
                   type_doc:
                     "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)",
                   doc:
                     "Default interval for throttling activity heartbeats in case ActivityOptions.heartbeat_timeout is unset. When the timeout is set in the ActivityOptions, throttling is set to heartbeat_timeout * 0.8"
                 ],
                 max_task_queue_activities_per_second: [
                   required: false,
                   type: :float,
                   doc:
                     "Sets the maximum number of activities per second the task queue will dispatch, controlled server-side. Note that this only takes effect upon an activity poll request. If multiple workers on the same queue have different values set, they will thrash with the last poller winning.

                      Setting this to a nonzero value will also disable eager activity execution."
                 ],
                 max_worker_activities_per_second: [
                   required: false,
                   type: :float,
                   doc:
                     "Limits the number of activities per second that this worker will process. The worker will not poll for new activities if by doing so it might receive and execute an activity which would cause it to exceed this limit. Negative, zero, or NaN values will cause building the options to fail."
                 ],
                 ignore_evicts_on_shutdown: [
                   default: false,
                   type: :boolean,
                   doc:
                     "If set false (default), shutdown will not finish until all pending evictions have been issued and replied to. If set true shutdown will be considered complete when the only remaining work is pending evictions.

                      This flag is useful during tests to avoid needing to deal with lots of uninteresting evictions during shutdown. Alternatively, if a lang implementation finds it easy to clean up during shutdown, setting this true saves some back-and-forth."
                 ],
                 graceful_shutdown_period: [
                   required: false,
                   type: {:tuple, [:pos_integer, {:in, [:seconds, :milliseconds]}]},
                   type_doc:
                     "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)",
                   doc:
                     "If set, core will issue cancels for all outstanding activities and nexus operations after shutdown has been initiated and this amount of time has elapsed"
                 ],
                 deployment_options: [
                   required: true,
                   type: :non_empty_keyword_list,
                   keys: [
                     version: [
                       required: true,
                       type: :non_empty_keyword_list,
                       doc: "The deployment version of this worker",
                       keys: [
                         build_id: [required: true, type: :string],
                         deployment_name: [required: true, type: :string]
                       ]
                     ],
                     use_worker_versioning: [
                       required: true,
                       type: :boolean,
                       doc:
                         "If set, opts in to the Worker Deployment Versioning feature, meaning this worker will only receive tasks for workflows it claims to be compatible with."
                     ],
                     default_versioning_behavior: [
                       required: false,
                       type: {:in, [:unspecified, :pinned, :auto_upgrade, nil]},
                       doc:
                         "The default versioning behavior to use for workflows that do not pass one to Core. It is a startup-time error to specify :unspecified here."
                     ]
                   ]
                 ],
                 nondeterminism_as_workflow_fail: [
                   default: true,
                   type: :boolean,
                   doc:
                     "When enabled, Nondeterminism Errors cause any workflow being processed by this worker to fail, rather than simply failing the workflow task."
                 ],
                 nondeterminism_as_workflow_fail_for_types: [
                   default: [],
                   type: {:list, :string}
                 ],
                 plugins: [
                   default: [],
                   type: {:list, :string},
                   doc: "List of plugins used by lang."
                 ]
               )

  @typedoc "Supported options:\n#{NimbleOptions.docs(@opts_schema)}"
  @type worker_opts :: unquote(NimbleOptions.option_typespec(@opts_schema))
  @type extra_opts :: [{:forward_polled_messages, pid()}]
  @type task_queue :: String.t()
  @type activity_type :: String.t()
  @type register_workflow_opts :: [{:name, WorkflowName.t()}]

  @spec new(TaskQueue.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
  def new(task_queue, opts \\ []) do
    opts = Keyword.put(opts, :task_queue, task_queue.queue_name)
    opts = Keyword.put_new(opts, :namespace, task_queue.client.namespace)

    with {:ok, validated} <- NimbleOptions.validate(opts, @opts_schema) do
      initialize_worker(task_queue, validated)
    end
  end

  @spec initialize_worker(TaskQueue.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
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
               [
                 config:
                   worker_opts(
                     id: worker_id,
                     namespace: opts[:namespace],
                     task_queue: opts[:task_queue],
                     deployment_options:
                       if(deploy = opts[:deployment_options],
                         do:
                           deployment(
                             version:
                               if(vers = deploy[:version],
                                 do:
                                   version(
                                     build_id: vers[:build_id],
                                     deployment_name: vers[:deployment_name]
                                   )
                               ),
                             use_worker_versioning: deploy[:use_worker_versioning],
                             default_versioning_behavior: deploy[:default_versioning_behavior]
                           )
                       ),
                     max_cached_workflows: opts[:max_cached_workflows],
                     nonsticky_to_sticky_poll_ratio: opts[:nonsticky_to_sticky_poll_ratio],
                     task_types:
                       if(types = opts[:task_types],
                         do:
                           task_types(
                             enable_workflows: types[:enable_workflows],
                             enable_local_activities: types[:enable_local_activities],
                             enable_remote_activities: types[:enable_remote_activities],
                             enable_nexus: types[:enable_nexus]
                           )
                       ),
                     sticky_queue_schedule_to_start_timeout:
                       if(timeout = opts[:sticky_queue_schedule_to_start_timeout],
                         do: Duration.from_tuple(timeout)
                       ),
                     max_heartbeat_throttle_interval:
                       if(interval = opts[:max_heartbeat_throttle_interval],
                         do: Duration.from_tuple(interval)
                       ),
                     default_heartbeat_throttle_interval:
                       if(interval = opts[:default_heartbeat_throttle_interval],
                         do: Duration.from_tuple(interval)
                       ),
                     graceful_shutdown_period:
                       if(period = opts[:graceful_shutdown_period],
                         do: Duration.from_tuple(period)
                       ),
                     nondeterminism_as_workflow_fail: opts[:nondeterminism_as_workflow_fail],
                     tuner:
                       if(tuner_opts = opts[:tuner],
                         do:
                           tuner(
                             workflow_slot_supplier:
                               slot_supplier_to_record(tuner_opts[:workflow_slot_supplier]),
                             activity_slot_supplier:
                               slot_supplier_to_record(tuner_opts[:activity_slot_supplier]),
                             local_activity_slot_supplier:
                               slot_supplier_to_record(tuner_opts[:local_activity_slot_supplier])
                           )
                       ),
                     nondeterminism_as_workflow_fail_for_types:
                       opts[:nondeterminism_as_workflow_fail_for_types],
                     plugins: opts[:plugins],
                     max_worker_activities_per_second: opts[:max_worker_activities_per_second],
                     max_task_queue_activities_per_second:
                       opts[:max_task_queue_activities_per_second],
                     identity_override: opts[:identity_override],
                     workflow_task_poller_behavior:
                       poller_to_record(opts[:workflow_task_poller_behavior]),
                     activity_task_poller_behavior:
                       poller_to_record(opts[:activity_task_poller_behavior])
                   )
               ],
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
          WorkflowName.server_recognized_name(workflow_mod, execute_fn)
        end)

      with {:ok, manager_pid} <- WorkerSupervisor.workflow_manager_pid(worker.id) do
        arities_resp = WorkflowName.execution_arities(workflow_mod, execute_fn)

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

  defp slot_supplier_to_record(kw) do
    if kw[:fixed_size] do
      fixed(size: kw[:fixed_size])
    else
      resource(
        target_mem_usage: kw[:target_mem_usage],
        target_cpu_usage: kw[:target_cpu_usage],
        min_slots: kw[:min_slots],
        max_slots: kw[:max_slots],
        ramp_throttle: kw[:ramp_throttle]
      )
    end
  end

  defp poller_to_record(kw) do
    if kw[:simple_maximum] do
      simple_maximum_poller(simple_maximum: kw[:simple_maximum])
    else
      autoscaling_poller(minimum: kw[:minimum], maximum: kw[:maximum], initial: kw[:initial])
    end
  end
end
