defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo do
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
  | 3 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 5 | **`last_modifier_identity`** | `string` | Identity of the last client who modified the configuration of this Deployment. Set to the |
  | 6 | **`manager_identity`** | `string` | Identity of the client that has the exclusive right to make changes to this Worker Deployment. |
  | 1 | **`name`** | `string` | Identifies a Worker Deployment. Must be unique within the namespace. |
  | 4 | **`routing_config`** | `Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig` |  |
  | 7 | **`routing_config_update_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.RoutingConfigUpdateState` | Indicates whether the routing_config has been fully propagated to all |
  | 2 | **`version_summaries`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary` | Deployment Versions that are currently tracked in this Deployment. A DeploymentVersion will be |

  ### Additional Notes

    * `last_modifier_identity` (`string`): Identity of the last client who modified the configuration of this Deployment. Set to the
      `identity` value sent by APIs such as `SetWorkerDeploymentCurrentVersion` and
      `SetWorkerDeploymentRampingVersion`.
    * `manager_identity` (`string`): Identity of the client that has the exclusive right to make changes to this Worker Deployment.
      Empty by default.
      If this is set, clients whose identity does not match `manager_identity` will not be able to make changes
      to this Worker Deployment. They can either set their own identity as the manager or unset the field to proceed.
    * `routing_config_update_state` (`Temporal.Protos.Temporal.Api.Enums.V1.RoutingConfigUpdateState`): Indicates whether the routing_config has been fully propagated to all
      relevant task queues and their partitions.
    * `version_summaries` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary`): Deployment Versions that are currently tracked in this Deployment. A DeploymentVersion will be
      cleaned up automatically if all the following conditions meet:
      - It does not receive new executions (is not current or ramping)
      - It has no active pollers (see WorkerDeploymentVersionInfo.pollers_status)
      - It is drained (see WorkerDeploymentVersionInfo.drainage_status)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string

  field :version_summaries, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary,
    json_name: "versionSummaries"

  field :create_time, 3, type: Google.Protobuf.Timestamp, json_name: "createTime"

  field :routing_config, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig,
    json_name: "routingConfig"

  field :last_modifier_identity, 5, type: :string, json_name: "lastModifierIdentity"
  field :manager_identity, 6, type: :string, json_name: "managerIdentity"

  field :routing_config_update_state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RoutingConfigUpdateState,
    json_name: "routingConfigUpdateState",
    enum: true
end
