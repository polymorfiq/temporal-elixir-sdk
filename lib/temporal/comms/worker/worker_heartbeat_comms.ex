defmodule Temporal.Comms.Worker.WorkerHeartbeatComms do
  alias Temporal.Client
  alias Temporal.Constants
  alias Temporal.Data.Worker.WorkerHeartbeat
  alias Temporal.Protos.Temporal.Api.Worker.V1, as: WorkerApi
  alias Temporal.Protos.Temporal.Api.Deployment.V1, as: DeploymentApi
  alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: WorkflowsSvcApi

  @spec send_heartbeat(Client.t(), WorkerHeartbeat.t()) :: :ok | {:error, term()}
  def send_heartbeat(client, hb) do
    deployment_version =
      if dv = hb.addr.deployment_version do
        %DeploymentApi.WorkerDeploymentVersion{
          build_id: dv.build_id,
          deployment_name: dv.deployment_name
        }
      else
        nil
      end

    heartbeat = %WorkerApi.WorkerHeartbeat{
      worker_instance_key: hb.addr.instance_key,
      worker_identity: hb.addr.identity,
      host_info: %WorkerApi.WorkerHostInfo{
        current_host_cpu_usage: hb.host.cpu_usage,
        current_host_mem_usage: hb.host.memory_usage,
        host_name: hb.host.hostname,
        process_id: hb.host.os_process_id,
        worker_grouping_key: hb.addr.grouping_key
      },
      task_queue: hb.addr.task_queue,
      deployment_version: deployment_version,
      sdk_name: Constants.sdk_name(),
      sdk_version: Constants.sdk_version(),
      status: :WORKER_STATUS_RUNNING,
      start_time: %Google.Protobuf.Timestamp{seconds: hb.worker_started_at |> DateTime.to_unix()},
      heartbeat_time: %Google.Protobuf.Timestamp{seconds: hb.heartbeat_at |> DateTime.to_unix()},
      elapsed_since_last_heartbeat:
        if(hb.last_heartbeat_at,
          do: DateTime.diff(hb.heartbeat_at, hb.last_heartbeat_at, :second),
          else: nil
        ),
      workflow_task_slots_info: %WorkerApi.WorkerSlotsInfo{
        current_available_slots: 5,
        current_used_slots: 0,
        last_interval_failure_tasks: 0,
        last_interval_processed_tasks: 0,
        slot_supplier_kind: "...",
        total_failed_tasks: 0,
        total_processed_tasks: 0
      },
      activity_task_slots_info: %WorkerApi.WorkerSlotsInfo{
        current_available_slots: 5,
        current_used_slots: 0,
        last_interval_failure_tasks: 0,
        last_interval_processed_tasks: 0,
        slot_supplier_kind: "...",
        total_failed_tasks: 0,
        total_processed_tasks: 0
      }
    }

    req = %WorkflowsSvcApi.RecordWorkerHeartbeatRequest{
      identity: hb.addr.identity,
      namespace: hb.addr.namespace,
      resource_id: hb.addr.grouping_key,
      worker_heartbeat: [heartbeat]
    }

    with {:ok, _reply} <-
           WorkflowsSvcApi.WorkflowService.Stub.record_worker_heartbeat(
             Client.channel(client),
             req
           ) do
      :ok
    else
      {:error, err} -> {:error, err}
    end
  end
end
