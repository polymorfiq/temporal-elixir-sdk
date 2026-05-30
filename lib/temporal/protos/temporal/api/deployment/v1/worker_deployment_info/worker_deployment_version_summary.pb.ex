defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary do
  @moduledoc """
  A Worker Deployment (Deployment, for short) represents all workers serving
  a shared set of Task Queues. Typically, a Deployment represents one service or
  application.
  A Deployment contains multiple Deployment Versions, each representing a different
  version of workers. (see documentation of WorkerDeploymentVersionInfo)
  Deployment records are created in Temporal server automatically when their
  first poller arrives to the server.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 13 | **`compute_config`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary` |  |
  | 2 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 6 | **`current_since_time`** | `Google.Protobuf.Timestamp` | Indicates whether the routing_config has been fully propagated to all |
  | 4 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` |  |
  | 5 | **`drainage_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo` | Identity of the client that has the exclusive right to make changes to this Worker Deployment. |
  | 3 | **`drainage_status`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus` | Identity of the last client who modified the configuration of this Deployment. Set to the |
  | 9 | **`first_activation_time`** | `Google.Protobuf.Timestamp` |  |
  | 12 | **`last_current_time`** | `Google.Protobuf.Timestamp` |  |
  | 10 | **`last_deactivation_time`** | `Google.Protobuf.Timestamp` |  |
  | 7 | **`ramping_since_time`** | `Google.Protobuf.Timestamp` |  |
  | 8 | **`routing_update_time`** | `Google.Protobuf.Timestamp` |  |
  | 11 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus` | Deployment Versions that are currently tracked in this Deployment. A DeploymentVersion will be |
  | 1 | **`version`** | `string` | Identifies a Worker Deployment. Must be unique within the namespace. |

  ### Additional Notes

    * `current_since_time` (`Google.Protobuf.Timestamp`): Indicates whether the routing_config has been fully propagated to all
      relevant task queues and their partitions.
    * `drainage_info` (`Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo`): Identity of the client that has the exclusive right to make changes to this Worker Deployment.
      Empty by default.
      If this is set, clients whose identity does not match `manager_identity` will not be able to make changes
      to this Worker Deployment. They can either set their own identity as the manager or unset the field to proceed.
    * `drainage_status` (`Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus`): Identity of the last client who modified the configuration of this Deployment. Set to the
      `identity` value sent by APIs such as `SetWorkerDeploymentCurrentVersion` and
      `SetWorkerDeploymentRampingVersion`.
    * `status` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus`): Deployment Versions that are currently tracked in this Deployment. A DeploymentVersion will be
      cleaned up automatically if all the following conditions meet:
      - It does not receive new executions (is not current or ramping)
      - It has no active pollers (see WorkerDeploymentVersionInfo.pollers_status)
      - It is drained (see WorkerDeploymentVersionInfo.drainage_status)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :version, 1, type: :string, deprecated: true

  field :status, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus,
    enum: true

  field :deployment_version, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime"

  field :drainage_status, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus,
    json_name: "drainageStatus",
    enum: true

  field :drainage_info, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo,
    json_name: "drainageInfo"

  field :current_since_time, 6, type: Google.Protobuf.Timestamp, json_name: "currentSinceTime"
  field :ramping_since_time, 7, type: Google.Protobuf.Timestamp, json_name: "rampingSinceTime"
  field :routing_update_time, 8, type: Google.Protobuf.Timestamp, json_name: "routingUpdateTime"

  field :first_activation_time, 9,
    type: Google.Protobuf.Timestamp,
    json_name: "firstActivationTime"

  field :last_current_time, 12, type: Google.Protobuf.Timestamp, json_name: "lastCurrentTime"

  field :last_deactivation_time, 10,
    type: Google.Protobuf.Timestamp,
    json_name: "lastDeactivationTime"

  field :compute_config, 13,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary,
    json_name: "computeConfig"
end
