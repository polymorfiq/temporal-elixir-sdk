defprotocol TemporalEngine.Client do
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy
  alias TemporalEngine.Worker
  alias TemporalEngine.WorkflowHandle

  require Record

  @spec create_worker(t(), worker_opts()) :: {:ok, Worker.t()} | {:error, reason :: term()}
  def create_worker(client, opts)

  Record.defrecord(:worker_opts, [
    :id,
    :namespace,
    :task_queue,
    :deployment_options,
    :max_cached_workflows,
    :nonsticky_to_sticky_poll_ratio,
    :task_types,
    :sticky_queue_schedule_to_start_timeout,
    :max_heartbeat_throttle_interval,
    :default_heartbeat_throttle_interval,
    :graceful_shutdown_period,
    :nondeterminism_as_workflow_fail,
    :tuner,
    :nondeterminism_as_workflow_fail_for_types,
    :plugins,
    :workflow_task_poller_behavior,
    :activity_task_poller_behavior,
    max_worker_activities_per_second: nil,
    max_task_queue_activities_per_second: nil,
    identity_override: nil
  ])

  @type worker_opts ::
          record(:worker_opts,
            id: String.t(),
            namespace: String.t(),
            task_queue: String.t(),
            deployment_options: deployment(),
            max_cached_workflows: pos_integer(),
            nonsticky_to_sticky_poll_ratio: float(),
            task_types: task_types(),
            sticky_queue_schedule_to_start_timeout: Duration.duration(),
            max_heartbeat_throttle_interval: Duration.duration(),
            default_heartbeat_throttle_interval: Duration.duration(),
            graceful_shutdown_period: Duration.duration(),
            nondeterminism_as_workflow_fail: bool(),
            tuner: tuner(),
            nondeterminism_as_workflow_fail_for_types: [String.t()],
            plugins: [String.t()],
            max_worker_activities_per_second: float() | nil,
            max_task_queue_activities_per_second: float() | nil,
            identity_override: String.t() | nil,
            workflow_task_poller_behavior: poller_behavior(),
            activity_task_poller_behavior: poller_behavior()
          )

  Record.defrecord(:deployment, [
    :version,
    :use_worker_versioning,
    default_versioning_behavior: nil
  ])

  @type deployment ::
          record(:deployment,
            version: version(),
            use_worker_versioning: bool(),
            default_versioning_behavior: pos_integer() | nil
          )

  Record.defrecord(:version, [
    :build_id,
    :deployment_name
  ])

  @type version :: record(:version, build_id: String.t(), deployment_name: String.t())

  Record.defrecord(:task_types, [
    :enable_workflows,
    :enable_local_activities,
    :enable_remote_activities,
    :enable_nexus
  ])

  @type task_types ::
          record(:task_types,
            enable_workflows: bool(),
            enable_local_activities: bool(),
            enable_remote_activities: bool(),
            enable_nexus: bool()
          )

  Record.defrecord(:tuner, [
    :workflow_slot_supplier,
    :activity_slot_supplier,
    :local_activity_slot_supplier
  ])

  @type tuner ::
          record(:tuner,
            workflow_slot_supplier: supplier(),
            activity_slot_supplier: supplier(),
            local_activity_slot_supplier: supplier()
          )
  @type supplier :: fixed() | resource()

  Record.defrecord(:fixed, [:size])
  @type fixed :: record(:fixed, size: pos_integer())

  Record.defrecord(:resource, [
    :target_mem_usage,
    :target_cpu_usage,
    :min_slots,
    :max_slots,
    :ramp_throttle
  ])

  @type poller_behavior :: simple_maximum_poller() | autoscaling_poller()

  Record.defrecord(:autoscaling_poller, [:minimum, :maximum, :initial])

  @type autoscaling_poller ::
          record(:autoscaling_poller,
            minimum: pos_integer(),
            maximum: pos_integer(),
            initial: pos_integer()
          )

  Record.defrecord(:simple_maximum_poller, [:simple_maximum])
  @type simple_maximum_poller :: record(:simple_maximum_poller, simple_maximum: pos_integer())

  @type resource ::
          record(:resource,
            target_mem_usage: float(),
            target_cpu_usage: float(),
            min_slots: pos_integer(),
            max_slots: pos_integer(),
            ramp_throttle: float()
          )

  @spec start_workflow(t(), definition(), inputs :: [Payload.payload()], workflow_start_opts()) ::
          {:ok, WorkflowHandle.t()} | {:error, reason :: term()}
  def start_workflow(client, definition, args, opts)

  Record.defrecord(:definition, [:name])
  @type definition :: record(:definition, name: String.t())

  Record.defrecord(:workflow_start_opts, [
    :task_queue,
    :workflow_id,
    id_reuse_policy: :unspecified,
    id_conflict_policy: :unspecified,
    enable_eager_workflow_start: false,
    priority: [priority_key: 0, fairness_key: "", fairness_weight: 1.0],
    links: [],
    completion_callbacks: [],
    execution_timeout: nil,
    run_timeout: nil,
    task_timeout: nil,
    cron_schedule: nil,
    search_attributes: nil,
    retry_policy: nil,
    start_signal: nil,
    header: %{},
    static_summary: nil,
    static_details: nil
  ])

  @type workflow_start_opts ::
          record(:workflow_start_opts,
            task_queue: String.t(),
            workflow_id: String.t(),
            id_reuse_policy: id_reuse_policy(),
            id_conflict_policy: id_conflict_policy(),
            execution_timeout: Duration.duration() | nil,
            run_timeout: Duration.duration() | nil,
            task_timeout: Duration.duration() | nil,
            cron_schedule: String.t() | nil,
            search_attributes: %{String.t() => Payload.payload()} | nil,
            enable_eager_workflow_start: bool(),
            retry_policy: RetryPolicy.policy() | nil,
            start_signal: start_signal() | nil,
            links: [link()],
            completion_callbacks: [callback()],
            priority: Priority.priority(),
            header: %{String.t() => String.t()},
            static_summary: String.t() | nil,
            static_details: String.t() | nil
          )

  @type id_conflict_policy :: :unspecified | :fail | :use_existing | :terminate_existing
  @type id_reuse_policy ::
          :unspecified
          | :allow_duplicate
          | :allow_duplicate_failed_only
          | :reject_duplicate
          | :terminate_if_running

  Record.defrecord(:start_signal, [:signal_name, inputs: [], header: %{}])

  @type start_signal ::
          record(:start_signal,
            signal_name: String.t(),
            inputs: [Payload.payload()],
            header: %{String.t() => Payload.payload()}
          )

  Record.defrecord(:link, fields: %{})
  @type link :: record(:link, fields: %{String.t() => Data.Payload.t()})

  @type callback :: nexus_cb() | internal_cb()

  Record.defrecord(:nexus_cb, [:url, links: [], header: %{}])

  @type nexus_cb ::
          record(:nexus_cb, url: String.t(), links: [link()], header: %{String.t() => String.t()})

  Record.defrecord(:internal_cb, [:data, links: []])
  @type internal_cb :: record(:internal_cb, data: binary(), links: [link()])

  @doc "A unique identifier for the client"
  @spec id(t()) :: String.t()
  def id(client)
end
