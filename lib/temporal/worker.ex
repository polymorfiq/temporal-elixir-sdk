defmodule Temporal.Worker do
  defstruct [:id, :task_queue]

  alias Temporal.Client
  alias Temporal.TaskQueue
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkflowActivation
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.WorkerRegistry

  @type t :: %__MODULE__{id: String.t(), task_queue: TaskQueue.t()}
  @type worker_opts :: WorkerOpts.opts() | extra_opts()
  @type extra_opts :: [{:forward_polled_messages, pid()}]
  @type task_queue :: String.t()

  @spec new(TaskQueue.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
  def new(task_queue, opts \\ []) do
    initialize_worker(task_queue, opts)
  end

  @spec poll_workflow_activations(t()) :: {:ok, WorkflowActivation.t()} | {:error, term()}
  def poll_workflow_activations(worker) do
    CoreWorker.poll_workflow_activations(worker.core, worker.runtime)
  end

  @spec initialize_worker(TaskQueue.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
  defp initialize_worker(task_queue, opts) do
    opts = task_queue.default_worker_opts ++ opts
    {extra_opts, core_opts} = Keyword.split(opts, [:forward_polled_messages])

    worker_id = UUID.uuid4()
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
         {:ok, core_client} <- Client.core_for_identity(client.identity),
         {:ok, workers_sup} <- ClientSupervisor.workers_sup_for_identity(client.identity) do
      reg_name = {:via, Registry, {WorkerRegistry, {:worker, worker_id}}}

      child_started =
        DynamicSupervisor.start_child(
          workers_sup,
          {WorkerSupervisor,
           {
             worker_id,
             core_runtime,
             core_client,
             extra_opts ++ [config: worker_opts],
             [name: reg_name]
           }}
        )

      with {:ok, _} <- child_started do
        {:ok, %__MODULE__{id: worker_id, task_queue: task_queue}}
      end
    end
  end
end
