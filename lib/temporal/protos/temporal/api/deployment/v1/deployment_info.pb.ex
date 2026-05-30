defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo do
  @moduledoc """
  `DeploymentInfo` holds information about a deployment. Deployment information is tracked
  automatically by server as soon as the first poll from that deployment reaches the server. There
  can be multiple task queue workers in a single deployment which are listed in this message.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` |  |
  | 5 | **`is_current`** | `bool` | If this deployment is the current deployment of its deployment series. |
  | 4 | **`metadata`** | `Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry` | A user-defined set of key-values. Can be updated as part of write operations to the |
  | 3 | **`task_queue_infos`** | `Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.TaskQueueInfo` |  |

  ### Additional Notes

    * `metadata` (`Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry`): A user-defined set of key-values. Can be updated as part of write operations to the
      deployment, such as `SetCurrentDeployment`.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment
  field :create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime"

  field :task_queue_infos, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.TaskQueueInfo,
    json_name: "taskQueueInfos"

  field :metadata, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry,
    map: true

  field :is_current, 5, type: :bool, json_name: "isCurrent"
end
