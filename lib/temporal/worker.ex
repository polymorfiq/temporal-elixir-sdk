defmodule Temporal.Worker do
  use Supervisor

  defstruct [:client, :task_queue, :instance_key, :worker]

  alias Temporal.Client
  alias Temporal.Time
  alias Temporal.Worker.WorkerAddress
  alias Temporal.Worker.DeploymentOptions
  alias Temporal.Worker.HeartbeatManager
  alias Temporal.Constants

  @temporal_prefix Constants.temporal_prefix()

  @type t() :: %__MODULE__{
          client: Client.t(),
          task_queue: task_queue(),
          instance_key: String.t(),
          worker: pid()
        }

  @type task_queue() :: String.t()
  @type worker_opt() ::
          {:worker_activities_per_second, pos_integer()}
          | {:worker_local_activities_per_second, pos_integer()}
          | {:task_queue_activities_per_second, pos_integer()}
          | {:max_concurrent_activity_execution_size, pos_integer()}
          | {:max_concurrent_local_activity_execution_size, pos_integer()}
          | {:max_concurrent_workflow_task_execution_size, pos_integer()}
          | {:max_concurrent_nexus_task_execution_size, pos_integer()}
          | {:max_concurrent_eager_activity_execution_size, pos_integer()}
          | {:max_concurrent_session_execution_size, pos_integer()}
          | {:max_concurrent_activity_task_pollers, pos_integer()}
          | {:max_concurrent_workflow_task_pollers, pos_integer()}
          | {:max_concurrent_nexus_task_pollers, pos_integer()}
          | {:enable_logging_in_replay, bool()}
          | {:sticky_schedule_to_start_timeout, Time.time_interval()}
          | {:workflow_panic_policy, :block_workflow | :fail_workflow}
          | {:worker_stop_timeout, Time.time_interval()}
          | {:enable_session_worker, bool()}
          | {:disable_workflow_worker, bool()}
          | {:disable_eager_activities, bool()}
          | {:local_activity_worker_only, bool()}
          | {:identity, String.t()}
          | {:max_heartbeat_throttle_interval, Time.time_interval()}
          | {:default_heartbeat_throttle_interval, Time.time_interval()}
          | {:deployment_options, DeploymentOptions.t()}

  @type init_arg() :: {Client.t(), task_queue(), [worker_opt()]}

  alias Temporal.Client
  alias Temporal.Constants

  @doc """
  ## Options
  - **`:worker_activities_per_second`** (*Default: `100_000.00`*)

    Sets the rate limiting on number of activities that can be executed per second per worker.\\
    This can be used to limit resources used by the worker and prevent downstream services from flooding.


    - `0.1` = One activity every 10 seconds
    - `100_000` = 100k activities every 1 second
    - `0` = Use default value

  - **`:worker_local_activities_per_second`** (*Default: `100_000.00`*)

    Sets the rate limiting on number of local activities that can be executed per second per worker.\\
    This can be used to limit resources used by the worker and prevent downstream services from flooding.

    - `0.1` = One local activity every 10 seconds
    - `100_000` = 100k local activities every 1 second
    - `0` = Use default value

  - **`:task_queue_activities_per_second`** (*Default: `100_000.00`*)

    This is managed by the server and controls activities per second for your **entire task queue** whereas `:worker_activities_per_second` controls activities only per worker.

    This can be used to limit resources used by the worker and prevent downstream services from flooding.

    - `0.1` = One activity every 10 seconds
    - `100_000` = 100k activities every 1 second
    - `0` = Use default value

    **NOTE:** Setting this to a non zero value will also disable eager activities.

  - **`:max_concurrent_activity_execution_size`** (*Default: `1_000`*)

    Sets the maximum concurrent activity executions this worker can have.\\
    The zero value of this uses the default value.

  - **`:max_concurrent_local_activity_execution_size`** (*Default: `1_000`*)

    Sets the maximum concurrent local activity executions this worker can have.\\
    The zero value of this uses the default value.

  - **`:max_concurrent_workflow_task_execution_size`** (*Default: `1_000`*)

    Sets the maximum concurrent workflow task executions this worker can have.

    The zero value of this uses the default value.

    **NOTE:** Due to internal logic where pollers alternate between stick and non-sticky queues, **this value cannot be 1** and will panic if set to that value.

  - **`:max_concurrent_nexus_task_execution_size`** (*Default: `1_000`*)

    Sets the maximum concurrent nexus task executions this worker can have.

    The zero value of this uses the default value.

  - **`:max_concurrent_eager_activity_execution_size`** (*Default: `0`*)

    Maximum number of eager activities that can be running.

    When non-zero, eager activity execution will not be requested for activities schedule by the workflow if it would cause the total number of running eager activities to exceed this value.

    For example, if this is set to 1000 and there are already 998 eager activities executing and a workflow task schedules 3 more, only the first 2 will request eager execution.

    The default of 0 means unlimited and therefore only bound by `:max_concurrent_activity_execution_size`

  - **`:max_concurrent_session_execution_size`** (*Default: `1_000`*)

    Sets the maximum number of concurrently running sessions the resource supports

  - **`:max_concurrent_activity_task_pollers`** (*Default: `2`*)

    Sets the maximum number of processes that will concurrently poll the temporal-server to retrieve activity tasks.

    Changing this value will affect the rate at which the worker is able to consume tasks from a task queue.

  - **`:max_concurrent_workflow_task_pollers`** (*Default: `2`*)

    Sets the maximum number of processes that will concurrently poll the temporal-server to retrieve workflow tasks.

    Changing this value will affect the rate at which the worker is able to consume tasks from a task queue.

    **NOTE:** Due to internal logic where pollers alternate between stick and non-sticky queues, **this value cannot be 1** and will panic if set to that value.

  - **`:max_concurrent_nexus_task_pollers`** (*Default: `2`*)

    Sets the maximum number of processes that will concurrently poll the temporal-server to retrieve nexus tasks.

    Changing this value will affect the rate at which the worker is able to consume tasks from a task queue.

  - **`:enable_logging_in_replay`** (*Default: `false`*)

    In the workflow code you can use workflow.GetLogger(ctx) to write logs. By default, the logger entry during replay mode so you won't see duplicate logs.

    This option will enable the logging in replay mode for debugging purposes.

  - **`:sticky_schedule_to_start_timeout`** (*Default: `{5, :second}`*)

    Sticky Execution allows for running the workflow tasks for one workflow execution on same worker host as an optimization for workflow execution.

    When sticky execution is enabled, worker keeps the workflow state in memory and new workflow tasks will be dispatched to the same worker.

    If this worker crashes, the sticky workflow task will timeout after the `sticky_schedule_to_start_timeout` and stickiness will be cleared from that workflow execution.

  - **`:workflow_panic_policy`** (*Default: `:block_workflow`*)

    Sets how workflow worker deals with non-deterministic history events (presumably arising from non-deterministic workflow definitions or non-backward compatible workflow definition changes) and other panics raised from workflow code.

    - `:block_workflow` causes workflow to get stuck in the workflow task retry loop. It is expected that after the problem is discovered and fixed the workflows are going to continue without any additional manual intervention.

    - `:fail_workflow` immediately fails workflow execution if workflow code throws panic or detects non-determinism. This feature is convenient during development.

      **WARNING:** Enabling `:fail_workflow` in production can cause all open workflows to fail on a single bug or bad deployment.

  - **`:worker_stop_timeout`** (*Default: `{0, :second}`*)

    Adds a graceful stop timeout to workers.

  - **`:enable_session_worker`** (*Default: `false`*)

    Enable this option to allow worker to process activities within sessions

  - **`:disable_workflow_worker`** (*Default: `false`*)

    If set to true, a workflow worker is not started for this worker and workflows cannot be registered with this worker.

    Use this if you only want your worker to execute activities.

  - **`:disable_eager_activities`** (*Default: `false`*)

    If set to true, activities will not be requested to execute eagerly from the same workflow regardless of `:max_concurrent_eager_activity_execution_size`.

    Eager activity execution means the server returns requested eager activities directly from the workflow task back to this worker which is faster than non-eager which may be dispatched to a separate worker.

    **NOTE:** Eager activities will automatically be disabled if TaskQueueActivitiesPerSecond is set.

  - **`:local_activity_worker_only`** (*Default: `false`*)

    If set to true worker will only handle workflow tasks and local activities.

    Non-local activities will not be executed by this worker.

  - **`:identity`** (*Default: `nil`*)

    If set overwrites the client level Identity value.


  - **`:max_heartbeat_throttle_interval`** (*Default: `{60, :second}`*)

    The maximum amount of time between sending each pending heartbeat to the server.

    Regardless of heartbeat timeout, no pending heartbeat will wait longer than this amount of time to send.

    To effectively disable heartbeat throttling, this can be set to something like 1 nanosecond, but it is not recommended


  - **`:default_heartbeat_throttle_interval`** (*Default: `{30, :second}`*)

    The default amount of time between sending each pending heartbeat to the server.

    This is used if the Activity options do not provide a `:heartbeat_timeout`. Otherwise, the interval becomes a value a bit smaller than the given `:heartbeat_timeout`

  - **`:deployment_options`** (*Default: `nil`*)

    See `Temporal.Worker.DeploymentOptions`.
  """
  @spec new(Client.t(), task_queue :: task_queue(), opts :: [worker_opt()]) ::
          {:ok, t()} | {:error, term()}

  def new(client, task_queue, opts \\ [])

  def new(_, @temporal_prefix <> _, _) do
    {:error, Constants.temporal_prefix_error()}
  end

  def new(client, task_queue, opts) do
    worker_resp =
      DynamicSupervisor.start_child(
        Temporal.Worker.Supervisor,
        {__MODULE__,
         {
           client,
           task_queue,
           opts
         }}
      )

    with {:ok, worker} <- worker_resp do
      {:ok,
       %__MODULE__{
         client: client,
         task_queue: task_queue,
         instance_key: UUID.uuid4(),
         worker: worker
       }}
    end
  end

  @spec start_link(init_arg()) :: {:ok, pid()} | {:error, term()}
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  @spec init(init_arg()) :: Supervisor.init_result()
  def init({client, task_queue, opts}) do
    identity =
      Keyword.get_lazy(opts, :identity, fn ->
        host_info = Temporal.Environment.latest_host_info()
        "#{inspect(self())}@#{host_info.hostname}@#{task_queue}"
      end)

    deployment_opts =
      Keyword.get(opts, :deployment_options, %DeploymentOptions{use_versioning: false})

    deployment_version =
      if deployment_opts.use_versioning do
        deployment_opts.version
      else
        nil
      end

    address = %WorkerAddress{
      namespace: Client.namespace(client),
      instance_key: UUID.uuid4(),
      identity: identity,
      task_queue: task_queue,
      deployment_version: deployment_version,
      grouping_key: Client.worker_grouping_key(client)
    }

    children = [
      {HeartbeatManager, {client, address}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
