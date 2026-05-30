defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsResponse.WorkerDeploymentSummary do
  @moduledoc """
  Automatically generated module for WorkerDeploymentSummary

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`create_time`** | `Google.Protobuf.Timestamp` | The list of worker deployments. |
  | 5 | **`current_version_summary`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary` |  |
  | 4 | **`latest_version_summary`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary` |  |
  | 1 | **`name`** | `string` |  |
  | 6 | **`ramping_version_summary`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary` |  |
  | 3 | **`routing_config`** | `Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime"

  field :routing_config, 3,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig,
    json_name: "routingConfig"

  field :latest_version_summary, 4,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary,
    json_name: "latestVersionSummary"

  field :current_version_summary, 5,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary,
    json_name: "currentVersionSummary"

  field :ramping_version_summary, 6,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary,
    json_name: "rampingVersionSummary"
end
