defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse do
  @moduledoc """
  Automatically generated module for DescribeWorkerDeploymentVersionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`version_task_queues`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue` | All the Task Queues that have ever polled from this Deployment version. |
  | 1 | **`worker_deployment_version_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_deployment_version_info, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo,
    json_name: "workerDeploymentVersionInfo"

  field :version_task_queues, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue,
    json_name: "versionTaskQueues"
end
