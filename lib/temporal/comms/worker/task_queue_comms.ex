defmodule Temporal.Comms.Worker.TaskQueueComms do
  alias Temporal.Client
  alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: WorkflowsSvcApi
  alias Temporal.Protos.Temporal.Api.Taskqueue.V1, as: TaskQueueApi
  alias Temporal.Protos.Temporal.Api.Enums.V1, as: EnumsApi
  alias Temporal.Protos.Temporal.Api.Common.V1, as: CommonApi
  alias Temporal.Protos.Temporal.Api.Deployment.V1, as: DeploymentApi

  def next_poll_request(worker) do
    deploy_ver = worker.address.deployment_version

    req = %WorkflowsSvcApi.PollWorkflowTaskQueueRequest{
      namespace: Client.namespace(worker.client),
      identity: worker.address.identity,
      worker_instance_key: worker.address.instance_key,
      binary_checksum: if(deploy_ver, do: deploy_ver.build_id, else: nil),
      worker_version_capabilities: if(deploy_ver, do: %CommonApi.WorkerVersionCapabilities{
        build_id: deploy_ver.build_id,
        use_versioning: true,
        deployment_series_name: deploy_ver.deployment_name
      }, else: nil),
      deployment_options: if(deploy_ver, do: %DeploymentApi.WorkerDeploymentOptions{
        build_id: deploy_ver.build_id,
        worker_versioning_mode: EnumsApi.WorkerVersioningMode.value(:WORKER_VERSIONING_MODE_VERSIONED),
        deployment_name: deploy_ver.deployment_name
      }, else: nil),
      task_queue: %TaskQueueApi.TaskQueue{
        name: worker.task_queue,
        kind: EnumsApi.TaskQueueKind.value(:TASK_QUEUE_KIND_NORMAL)
      }
    }

    with {:ok, polled} <- WorkflowsSvcApi.WorkflowService.Stub.poll_workflow_task_queue(Client.channel(worker.client), req) do
      polled
    end
  end
end