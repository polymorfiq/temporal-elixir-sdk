alias Temporal.Client
alias Temporal.Worker
alias Temporal.Comms.Worker.TaskQueueComms
alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: WorkflowsSvcApi
alias Temporal.Protos.Temporal.Api.Taskqueue.V1, as: TaskQueueApi
alias Temporal.Protos.Temporal.Api.Enums.V1, as: EnumsApi
alias Temporal.Protos.Temporal.Api.Common.V1, as: CommonApi
alias Temporal.Protos.Temporal.Api.Deployment.V1, as: DeploymentApi

defmodule SampleWorkflow do
  def execute(_ctx, input) do
    {:ok, "Hello, #{input}"}
  end
end

{:ok, runtime} = Temporal.CoreSdk.CoreRuntime.new()

client_opts = %Temporal.CoreSdk.Data.ClientOpts{
  target_host: "localhost:7233",
  client_name: "temporal-elixir",
  client_version: "0.0.1",
  identity: "iex-repl",
  rpc_retry: %Temporal.CoreSdk.Data.ClientRetryOpts{
    initial_interval_secs: 30.0,
    randomization_factor: 5.0,
    multiplier: 2.0,
    max_interval_secs: 60.0,
    max_elapsed_time_secs: 60.0,
    max_retries: 30
  }
}

{:ok, client} = Temporal.CoreSdk.CoreClient.new(runtime, client_opts)

worker_opts = %Temporal.CoreSdk.Data.WorkerOpts{
  namespace: "default",
  task_queue: "default",
  deployment_options: %Temporal.CoreSdk.Data.WorkerDeploymentOpts{
    version: %Temporal.CoreSdk.Data.WorkerDeploymentVersion{
      build_id: "0.0.1",
      deployment_name: "iex-repl-deploy"
    },
    use_worker_versioning: true,
    default_versioning_behavior: 0
  },
  max_cached_workflows: 100,
  nonsticky_to_sticky_poll_ratio: 0.5,
  enable_workflows: true,
  enable_local_activities: true,
  enable_remote_activities: true,
  enable_nexus: true,
  sticky_queue_schedule_to_start_timeout_secs: 300.0,
  max_heartbeat_throttle_interval_secs: 300.00,
  default_heartbeat_throttle_interval_secs: 30.0,
  graceful_shutdown_period_secs: 5.0,
  nondeterminism_as_workflow_fail: true,
  tuner: %Temporal.CoreSdk.Data.WorkerTunerOpts{
    workflow_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    },
    activity_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    },
    local_activity_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    }
  },
  nondeterminism_as_workflow_fail_for_types: [],
  plugins: [],
  max_worker_activities_per_second: nil,
  max_task_queue_activities_per_second: nil,
  identity_override: nil,
  workflow_task_poller_behavior: %Temporal.CoreSdk.Data.WorkerPollerOpts{
    simple_maximum: %Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
  },
  activity_task_poller_behavior:  %Temporal.CoreSdk.Data.WorkerPollerOpts{
    simple_maximum: %Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
  }
}

{:ok, worker} = Temporal.CoreSdk.CoreWorker.new(runtime, client, worker_opts)

#{:ok, client} = Temporal.dial_client("localhost:7233")
#{:ok, worker} = Temporal.Worker.new(client, "default")

#Worker.register_workflow(worker, SampleWorkflow)