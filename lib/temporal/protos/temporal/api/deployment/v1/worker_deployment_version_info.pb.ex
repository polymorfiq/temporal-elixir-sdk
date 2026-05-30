defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo do
  @moduledoc """
  A Worker Deployment Version (Version, for short) represents all workers of the same
  code and config within a Deployment. Workers of the same Version are expected to
  behave exactly the same so when executions move between them there are no
  non-determinism issues.
  Worker Deployment Versions are created in Temporal server automatically when
  their first poller arrives to the server.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 16 | **`compute_config`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig` | Optional. Contains the new worker compute configuration for the Worker |
  | 3 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 5 | **`current_since_time`** | `Google.Protobuf.Timestamp` | (-- api-linter: core::0140::prepositions=disabled |
  | 2 | **`deployment_name`** | `string` | Deprecated. User deployment_version.deployment_name. |
  | 11 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 9 | **`drainage_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo` | Helps user determine when it is safe to decommission the workers of this |
  | 12 | **`first_activation_time`** | `Google.Protobuf.Timestamp` | Timestamp when this version first became current or ramping. |
  | 15 | **`last_current_time`** | `Google.Protobuf.Timestamp` | Timestamp when this version last became current. |
  | 13 | **`last_deactivation_time`** | `Google.Protobuf.Timestamp` | Timestamp when this version last stopped being current or ramping. |
  | 17 | **`last_modifier_identity`** | `string` | Identity of the last client who modified the configuration of this Version. |
  | 10 | **`metadata`** | `Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata` | Arbitrary user-provided metadata attached to this version. |
  | 7 | **`ramp_percentage`** | `float` | Range: [0, 100]. Must be zero if the version is not ramping (i.e. `ramping_since_time` is nil). |
  | 6 | **`ramping_since_time`** | `Google.Protobuf.Timestamp` | (-- api-linter: core::0140::prepositions=disabled |
  | 4 | **`routing_changed_time`** | `Google.Protobuf.Timestamp` | Last time `current_since_time`, `ramping_since_time, or `ramp_percentage` of this version changed. |
  | 14 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus` | The status of the Worker Deployment Version. |
  | 8 | **`task_queue_infos`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo` | All the Task Queues that have ever polled from this Deployment version. |
  | 1 | **`version`** | `string` | Deprecated. Use `deployment_version`. |

  ### Additional Notes

    * `compute_config` (`Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig`): Optional. Contains the new worker compute configuration for the Worker
      Deployment. Used for worker scale management.
    * `current_since_time` (`Google.Protobuf.Timestamp`): (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: 'Since' captures the field semantics despite being a preposition. --)
      Unset if not current.
    * `drainage_info` (`Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo`): Helps user determine when it is safe to decommission the workers of this
      Version. Not present when version is current or ramping.
      Current limitations:
      - Not supported for Unversioned mode.
      - Periodically refreshed, may have delays up to few minutes (consult the
        last_checked_time value).
      - Refreshed only when version is not current or ramping AND the status is not
        "drained" yet.
      - Once the status is changed to "drained", it is not changed until the Version
        becomes Current or Ramping again, at which time the drainage info is cleared.
        This means if the Version is "drained" but new workflows are sent to it via
        Pinned Versioning Override, the status does not account for those Pinned-override
        executions and remains "drained".
    * `last_current_time` (`Google.Protobuf.Timestamp`): Timestamp when this version last became current.
      Can be used to determine whether a version has ever been Current.
    * `last_deactivation_time` (`Google.Protobuf.Timestamp`): Timestamp when this version last stopped being current or ramping.
      Cleared if the version becomes current or ramping again.
    * `last_modifier_identity` (`string`): Identity of the last client who modified the configuration of this Version.
      As of now, this field only covers changes through the following APIs:
      - `CreateWorkerDeploymentVersion`
      - `UpdateWorkerDeploymentVersionComputeConfig`
      - `UpdateWorkerDeploymentVersionMetadata`
    * `ramp_percentage` (`float`): Range: [0, 100]. Must be zero if the version is not ramping (i.e. `ramping_since_time` is nil).
      Can be in the range [0, 100] if the version is ramping.
    * `ramping_since_time` (`Google.Protobuf.Timestamp`): (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: 'Since' captures the field semantics despite being a preposition. --)
      Unset if not ramping. Updated when the version first starts ramping, not on each ramp change.
    * `task_queue_infos` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo`): All the Task Queues that have ever polled from this Deployment version.
      Deprecated. Use `version_task_queues` in DescribeWorkerDeploymentVersionResponse instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :version, 1, type: :string, deprecated: true

  field :status, 14,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus,
    enum: true

  field :deployment_version, 11,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :deployment_name, 2, type: :string, json_name: "deploymentName"
  field :create_time, 3, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :routing_changed_time, 4, type: Google.Protobuf.Timestamp, json_name: "routingChangedTime"
  field :current_since_time, 5, type: Google.Protobuf.Timestamp, json_name: "currentSinceTime"
  field :ramping_since_time, 6, type: Google.Protobuf.Timestamp, json_name: "rampingSinceTime"

  field :first_activation_time, 12,
    type: Google.Protobuf.Timestamp,
    json_name: "firstActivationTime"

  field :last_current_time, 15, type: Google.Protobuf.Timestamp, json_name: "lastCurrentTime"

  field :last_deactivation_time, 13,
    type: Google.Protobuf.Timestamp,
    json_name: "lastDeactivationTime"

  field :ramp_percentage, 7, type: :float, json_name: "rampPercentage"

  field :task_queue_infos, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo,
    json_name: "taskQueueInfos"

  field :drainage_info, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo,
    json_name: "drainageInfo"

  field :metadata, 10, type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata

  field :compute_config, 16,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig,
    json_name: "computeConfig"

  field :last_modifier_identity, 17, type: :string, json_name: "lastModifierIdentity"
end
