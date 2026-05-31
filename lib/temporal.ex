defmodule Temporal do
  defstruct [:channel]

  alias Temporal.Protos.Temporal.Api.Deployment.V1, as: Deployment
  alias Temporal.Protos.Temporal.Api.Worker.V1, as: Worker
  alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: Workflows

  def client(host) do
    {:ok, channel} = GRPC.Stub.connect(host)
    %__MODULE__{channel: channel}
  end

  def test_heartbeat do
    {:ok, channel} = GRPC.Stub.connect("localhost:7233")

    heartbeat = %Worker.WorkerHeartbeat{
      worker_instance_key: "my-worker-instance",
      worker_identity: "my-worker-ident",
      host_info: %Worker.WorkerHostInfo{
        current_host_cpu_usage: 0.0,
        current_host_mem_usage: 0.0,
        host_name: "my-host",
        process_id: "123-456",
        worker_grouping_key: "group-worker"
      },
      task_queue: "my-task-queue",
      deployment_version: %Deployment.WorkerDeploymentVersion{
        build_id: "1.0.2",
        deployment_name: "my-deploy"
      },
      sdk_name: "temporal-elixir",
      sdk_version: "v0.0.1",
      status: :WORKER_STATUS_RUNNING,
      start_time: %Google.Protobuf.Timestamp{seconds: DateTime.utc_now() |> DateTime.to_unix()},
      heartbeat_time: %Google.Protobuf.Timestamp{
        seconds: DateTime.utc_now() |> DateTime.to_unix()
      },
      elapsed_since_last_heartbeat: nil,
      workflow_task_slots_info: %Worker.WorkerSlotsInfo{
        current_available_slots: 5,
        current_used_slots: 0,
        last_interval_failure_tasks: 0,
        last_interval_processed_tasks: 0,
        slot_supplier_kind: "...",
        total_failed_tasks: 0,
        total_processed_tasks: 0
      },
      activity_task_slots_info: %Worker.WorkerSlotsInfo{
        current_available_slots: 5,
        current_used_slots: 0,
        last_interval_failure_tasks: 0,
        last_interval_processed_tasks: 0,
        slot_supplier_kind: "...",
        total_failed_tasks: 0,
        total_processed_tasks: 0
      }
    }

    req = %Workflows.RecordWorkerHeartbeatRequest{
      identity: "heartbeat-ident",
      namespace: "default",
      resource_id: "group-worker",
      worker_heartbeat: [heartbeat]
    }

    {:ok, reply} = channel |> Workflows.WorkflowService.Stub.record_worker_heartbeat(req)
    reply |> IO.inspect(label: "hmm")
  end
end
