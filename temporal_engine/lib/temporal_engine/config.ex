defmodule TemporalEngine.Config do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Config
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Common

  deftype :worker_config do
    @structdoc "Defines per-worker configuration options"

    @doc "Fort the lang SDK - helps track and interact with a unique worker."
    @type id :: required :: String.t()

    @doc "The Temporal service namespace this worker is bound to"
    @type namespace :: required :: String.t()

    @doc "What task queue will this worker poll from? This task queue name will be used for both workflow and activity polling."
    @type task_queue :: required :: String.t()

    @doc "A human-readable string that can identify this worker. Using something like sdk version and host name is a good default. If set, overrides the identity set (if any) on the client used by this worker."
    @type client_identity_override :: String.t()

    @doc """
    If set nonzero, workflows will be cached and sticky task queues will be used, meaning that history updates are applied incrementally to suspended instances of workflow execution.

    Workflows are evicted according to a least-recently-used policy once the cache maximum is reached. Workflows may also be explicitly evicted at any time, or as a result of errors or failures.
    """
    @type max_cached_workflows :: pos_integer()

    @doc "Set a tuner for this worker. Either this or at least one of the max_outstanding_* fields must be set."
    @type tuner :: nested!(Config.worker_tuner())

    @doc """
    Maximum number of concurrent poll workflow task requests we will perform at a time on this worker’s task queue.

    See also `nonsticky_to_sticky_poll_ratio`. If using `simple_maximum`, Must be at least `2` when `max_cached_workflows > 0`, or is an error.
    """
    @default [simple_maximum: 100]
    @type workflow_task_poller_behavior ::
            nested!(Config.simple_maximum_poller()) | nested!(Config.autoscaling_poller())

    @doc """
    Only applies when using `poller_behavior` of type `simple_maximum`

    `(max workflow task polls * this number)` is the number of max pollers that will be allowed for the nonsticky queue when sticky tasks are enabled

    If both defaults are used, the sticky queue will allow `4` max pollers while the nonsticky queue will allow `1`. The minimum for either poller is `1`, so if the maximum allowed is `1` and sticky queues are enabled, there will be `2` concurrent polls.
    """
    @default 0.2
    @type nonsticky_to_sticky_poll_ratio :: required :: float()

    @doc "Maximum number of concurrent poll activity task requests we will perform at a time on this worker’s task queue"
    @default [simple_maximum: 100]
    @type activity_task_poller_behavior ::
            nested!(Config.simple_maximum_poller()) | nested!(Config.autoscaling_poller())

    @doc "Maximum number of concurrent poll nexus task requests we will perform at a time on this worker’s task queue"
    @default [simple_maximum: 100]
    @type nexus_task_poller_behavior :: nested!(Config.simple_maximum_poller())

    @doc """
    Specifies which task types this worker will poll for.

    Note: At least one task type must be specified or the worker will fail validation.
    """
    @type task_types :: required :: nested!(Config.worker_task_types())

    @doc "How long a workflow task is allowed to sit on the sticky queue before it is timed out and moved to the non-sticky queue where it may be picked up by any worker."
    @default [seconds: 60]
    @type sticky_queue_schedule_to_start_timeout :: required :: nested!(Duration.duration())

    @doc "Longest interval for throttling activity heartbeats"
    @default [seconds: 60]
    @type max_heartbeat_throttle_interval :: required :: nested!(Duration.duration())

    @doc "Default interval for throttling activity heartbeats in case `ActivityOptions.heartbeat_timeout` is unset. When the timeout is set in the `ActivityOptions`, throttling is set to heartbeat_timeout * 0.8."
    @default [seconds: 300]
    @type default_heartbeat_throttle_interval :: required :: nested!(Duration.duration())

    @doc """
    Sets the maximum number of activities per second the task queue will dispatch, controlled server-side.

    Note that this only takes effect upon an activity poll request. If multiple workers on the same queue have different values set, they will thrash with the last poller winning.

    Setting this to a nonzero value will also disable eager activity execution.
    """
    @type max_task_queue_activities_per_second :: float()

    @doc """
    Limits the number of activities per second that this worker will process. The worker will not poll for new activities if by doing so it might receive and execute an activity which would cause it to exceed this limit.

    Negative, zero, or NaN values will cause building the options to fail.
    """
    @type max_worker_activities_per_second :: float()

    @doc """
    If set false (default), shutdown will not finish until all pending evictions have been issued and replied to. If set true shutdown will be considered complete when the only remaining work is pending evictions.

    This flag is useful during tests to avoid needing to deal with lots of uninteresting evictions during shutdown. Alternatively, if a lang implementation finds it easy to clean up during shutdown, setting this true saves some back-and-forth.
    """
    @default false
    @type ignore_evicts_on_shutdown :: required :: bool()

    @doc "If set, core will issue cancels for all outstanding activities and nexus operations after shutdown has been initiated and this amount of time has elapsed."
    @type graceful_shutdown_period :: nested!(Duration.duration())

    @doc "The amount of time core will wait before timing out activities using its own local timers after one of them elapses. This is to avoid racing with server’s own tracking of the timeout."
    @default [seconds: 5, nanos: 0]
    @type local_timeout_buffer_for_activities :: required :: nested!(Duration.duration())

    @doc "Any error types listed here will cause any workflow being processed by this worker to fail, rather than simply failing the workflow task."
    @default [:nondeterminism]
    @type workflow_failure_errors :: required :: [:nondeterminism]

    @doc "Like `workflow_failure_errors`, but specific to certain workflow types (the map key)."
    @default %{}
    @type workflow_types_to_failure_errors ::
            required :: %{String.t() => :nondeterminism}

    @doc """
    The maximum allowed number of workflow tasks that will ever be given to this worker at one time.

    Note that one workflow task may require multiple activations - so the WFT counts as “outstanding” until all activations it requires have been completed.

    Must be at least `2` if max_cached_workflows is `> 0`, or is an error.
    """
    @type max_outstanding_workflow_tasks :: pos_integer()

    @doc """
    The maximum number of activity tasks that will ever be given to this worker concurrently.

    Mutually exclusive with `tuner`
    """
    @type max_outstanding_activities :: pos_integer()

    @doc """
    The maximum number of local activity tasks that will ever be given to this worker concurrently.

    Mutually exclusive with `tuner`
    """
    @type max_outstanding_local_activities :: pos_integer()

    @doc """
    The maximum number of nexus tasks that will ever be given to this worker concurrently.

    Mutually exclusive with `tuner`
    """
    @type max_outstanding_nexus_tasks :: pos_integer()

    @doc "A versioning strategy for this worker."
    @type versioning_strategy :: required :: nested!(Config.worker_deployment_options())

    @doc "List of plugins used by lang."
    @default []
    @type plugins :: required :: [nested!(Config.plugin_info())]

    @doc "Skips the single worker+client+namespace+task_queue check"
    @default false
    @type skip_client_worker_set_check :: required :: bool()

    @doc "List of storage drivers used by lang."
    @default []
    @type storage_drivers :: required :: [nested!(Config.storage_driver_info())]

    @default true
    @type nondeterminism_as_workflow_fail :: required :: boolean()

    @default []
    @type nondeterminism_as_workflow_fail_for_types :: required :: [String.t()]
  end

  deftype :worker_task_types do
    @doc "Whether workflow tasks are enabled."
    @default false
    @type enable_workflows :: required :: bool()

    @doc "Whether local activity tasks are enabled."
    @default false
    @type enable_local_activities :: required :: bool()

    @doc "Whether remote activity tasks are enabled."
    @default false
    @type enable_remote_activities :: required :: bool()

    @doc "Whether nexus tasks are enabled."
    @default false
    @type enable_nexus :: required :: bool()
  end

  deftype :worker_deployment_options do
    @structdoc "Configuration for worker deployment versioning."

    @doc "The deployment version of this worker."
    @type version :: required :: nested!(Common.worker_deployment_version())

    @doc "If set, opts in to the Worker Deployment Versioning feature, meaning this worker will only receive tasks for workflows it claims to be compatible with."
    @type use_worker_versioning :: required :: bool()

    @doc """
    The default versioning behavior to use for workflows that do not pass one to Core.

    It is a startup-time error to specify `:unspecified` here.
    """
    @type default_versioning_behavior :: :unspecified | :pinned | :auto_upgrade
  end

  deftype :worker_tuner do
    @type workflow_slot_supplier ::
            required ::
            nested!(Config.fixed_slot_supplier())
            | nested!(Config.resource_based_slot_supplier())
    @type activity_slot_supplier ::
            required ::
            nested!(Config.fixed_slot_supplier())
            | nested!(Config.resource_based_slot_supplier())
    @type local_activity_slot_supplier ::
            required ::
            nested!(Config.fixed_slot_supplier())
            | nested!(Config.resource_based_slot_supplier())
  end

  deftype :fixed_slot_supplier do
    @structdoc "Create a slot supplier which will only hand out at most the provided number of slots"

    @doc "Number of slots to hand out"
    @type size :: required :: pos_integer()
  end

  deftype :resource_based_slot_supplier do
    @structdoc "Create an instance attempting to target the provided memory and cpu thresholds as values between 0 and 1."

    @type target_mem_usage :: required :: float()
    @type target_cpu_usage :: required :: float()
    @type min_slots :: required :: pos_integer()
    @type max_slots :: required :: pos_integer()
    @type ramp_throttle :: required :: float()
  end

  deftype :plugin_info do
    @doc "The name of the plugin"
    @type name :: required :: String.t()

    @doc "The version of the plugin, may be empty."
    @default ""
    @type version :: required :: String.t()
  end

  deftype :storage_driver_info do
    @doc "The type of the driver"
    @type type :: required :: String.t()
  end

  @type workflow_error_type :: :nondeterminism
  @type workflow_error_type_opts :: workflow_error_type()

  @type poller_behavior :: simple_maximum_poller() | autoscaling_poller()
  @type poller_behavior_opts :: simple_maximum_poller_opts() | autoscaling_poller_opts()

  deftype :simple_maximum_poller do
    @type simple_maximum :: required :: pos_integer()
  end

  deftype :autoscaling_poller do
    @type minimum :: required :: pos_integer()
    @type maximum :: required :: pos_integer()
    @type initial :: required :: pos_integer()
  end
end
