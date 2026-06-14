defmodule TemporalEngineNif.Data.WorkerOpts do
  defstruct [
    :namespace,
    :task_queue,
    :deployment_options,
    :max_cached_workflows,
    :nonsticky_to_sticky_poll_ratio,
    :enable_workflows,
    :enable_local_activities,
    :enable_remote_activities,
    :enable_nexus,
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
  ]

  alias TemporalEngineNif.Data.WorkerDeploymentOpts
  alias TemporalEngineNif.Data.WorkerTunerOpts
  alias TemporalEngineNif.Data.WorkerPollerOpts

  @type t :: %__MODULE__{
          namespace: String.t(),
          task_queue: String.t(),
          deployment_options: WorkerDeploymentOpts.t(),
          max_cached_workflows: pos_integer(),
          nonsticky_to_sticky_poll_ratio: float(),
          enable_workflows: bool(),
          enable_local_activities: bool(),
          enable_remote_activities: bool(),
          enable_nexus: bool(),
          sticky_queue_schedule_to_start_timeout: Duration.duration(),
          max_heartbeat_throttle_interval: Duration.duration(),
          default_heartbeat_throttle_interval: Duration.duration(),
          graceful_shutdown_period: Duration.duration(),
          nondeterminism_as_workflow_fail: bool(),
          tuner: WorkerTunerOpts.t(),
          nondeterminism_as_workflow_fail_for_types: [String.t()],
          plugins: [String.t()],
          max_worker_activities_per_second: float() | nil,
          max_task_queue_activities_per_second: float() | nil,
          identity_override: String.t() | nil,
          workflow_task_poller_behavior: WorkerPollerOpts.t(),
          activity_task_poller_behavior: WorkerPollerOpts.t()
        }

  @type opts :: [
          {:namespace, String.t()}
          | {:task_queue, String.t()}
          | {:deployment_options, WorkerDeploymentOpts.opts()}
          | {:max_cached_workflows, pos_integer()}
          | {:nonsticky_to_sticky_poll_ratio, float()}
          | {:enable_workflows, bool()}
          | {:enable_local_activities, bool()}
          | {:enable_remote_activities, bool()}
          | {:enable_nexus, bool()}
          | {:sticky_queue_schedule_to_start_timeout, Duration.duration()}
          | {:max_heartbeat_throttle_interval, Duration.duration()}
          | {:default_heartbeat_throttle_interval, Duration.duration()}
          | {:graceful_shutdown_period, Duration.duration()}
          | {:nondeterminism_as_workflow_fail, bool()}
          | {:nondeterminism_as_workflow_fail_for_types, [String.t()]}
          | {:tuner, WorkerTunerOpts.opts()}
          | {:plugins, [String.t()]}
          | {:max_worker_activities_per_second, float()}
          | {:max_task_queue_activities_per_second, float()}
          | {:identity_override, String.t()}
          | {:workflow_task_poller_behavior, WorkerPollerOpts.opts()}
          | {:activity_task_poller_behavior, WorkerPollerOpts.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    worker = struct!(__MODULE__, opts)

    worker =
      update_in(
        worker,
        [Access.key(:deployment_options)],
        &WorkerDeploymentOpts.with_opts!(&1)
      )

    worker = update_in(worker, [Access.key(:tuner)], &WorkerTunerOpts.with_opts!/1)

    worker =
      update_in(
        worker,
        [Access.key(:workflow_task_poller_behavior)],
        &WorkerPollerOpts.with_opts!/1
      )

    worker =
      update_in(
        worker,
        [Access.key(:activity_task_poller_behavior)],
        &WorkerPollerOpts.with_opts!/1
      )

    worker
  end
end
