defmodule Temporal.Worker do
  defstruct [:runtime, :client, :core]

  alias Temporal.Client
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkerDeploymentOpts
  alias Temporal.CoreSdk.Data.WorkerDeploymentVersion
  alias Temporal.CoreSdk.Data.WorkerTunerOpts
  alias Temporal.CoreSdk.Data.WorkerSlotSupplierOpts
  alias Temporal.CoreSdk.Data.WorkerPollerOpts
  alias Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts
  alias Temporal.CoreSdk.Data.WorkflowActivation

  @type t :: %__MODULE__{client: Client.t()}
  @type worker_opts :: []
  @type task_queue :: String.t()

  @spec new(Client.t(), task_queue(), worker_opts()) :: {:ok, t()} | {:error, term()}
  def new(client, task_queue, opts \\ []) do
    opts = opts ++ [task_queue: task_queue]

    with :ok <- validate_opts(opts) do
      initialize_worker(client, opts)
    end
  end

  @spec poll_workflow_activations(t()) :: {:ok, WorkflowActivation.t()} | {:error, term()}
  def poll_workflow_activations(worker) do
    CoreWorker.poll_workflow_activations(worker.core, worker.runtime)
  end

  @spec validate_opts(worker_opts()) :: :ok | {:error, term()}
  defp validate_opts(opts) do
    cond do
      !opts[:task_queue] -> {:error, ":task_queue is a required argument"}
      true -> :ok
    end
  end

  @spec initialize_worker(Client.t(), worker_opts()) :: {:ok, t()} | {:error, term()}
  defp initialize_worker(client, opts) do
    worker_opts = %WorkerOpts{
      namespace: client.namespace,
      task_queue: Keyword.fetch!(opts, :task_queue),
      deployment_options: %WorkerDeploymentOpts{
        version: %WorkerDeploymentVersion{
          build_id: "0.0.1",
          deployment_name: "iex-repl-deploy"
        },
        use_worker_versioning: false,
        default_versioning_behavior: 0
      },
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
      tuner: %WorkerTunerOpts{
        workflow_slot_supplier: %WorkerSlotSupplierOpts{
          fixed_size: 10
        },
        activity_slot_supplier: %WorkerSlotSupplierOpts{
          fixed_size: 10
        },
        local_activity_slot_supplier: %WorkerSlotSupplierOpts{
          fixed_size: 10
        }
      },
      nondeterminism_as_workflow_fail_for_types: [],
      plugins: [],
      max_worker_activities_per_second: 60,
      max_task_queue_activities_per_second: 60,
      identity_override: nil,
      workflow_task_poller_behavior: %WorkerPollerOpts{
        simple_maximum: %WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
      },
      activity_task_poller_behavior: %WorkerPollerOpts{
        simple_maximum: %WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
      }
    }

    with  {:ok, core_runtime} <- Client.core_runtime(client),
          {:ok, core_client} <- Client.core_for_identity(client.identity),
          {:ok, core} <- CoreWorker.new(core_runtime, core_client, worker_opts) do
      {:ok, %__MODULE__{client: client, runtime: core_runtime, core: core}}
    end
  end
end
