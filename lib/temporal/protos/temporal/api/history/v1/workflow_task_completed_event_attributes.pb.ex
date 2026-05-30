defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskCompletedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowTaskCompletedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`binary_checksum`** | `string` | Binary ID of the worker who completed this task |
  | 7 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | The deployment that completed this task. May or may not be set for unversioned workers, |
  | 11 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The Worker Deployment Version that completed this task. Must be set if `versioning_behavior` |
  | 3 | **`identity`** | `string` | Identity of the worker who completed this task |
  | 13 | **`metering_metadata`** | `Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata` | Local usage data sent during workflow task completion and recorded here for posterity |
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `WORKFLOW_TASK_SCHEDULED` event this task corresponds to |
  | 6 | **`sdk_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata` | Data the SDK wishes to record for itself, but server need not interpret, and does not |
  | 2 | **`started_event_id`** | `int64` | The id of the `WORKFLOW_TASK_STARTED` event this task corresponds to |
  | 8 | **`versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior` | Versioning behavior sent by the worker that completed this task for this particular workflow |
  | 10 | **`worker_deployment_name`** | `string` | The name of Worker Deployment that completed this task. Must be set if `versioning_behavior` |
  | 9 | **`worker_deployment_version`** | `string` | The Worker Deployment Version that completed this task. Must be set if `versioning_behavior` |
  | 5 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this workflow task. If present, the `build_id` field |

  ### Additional Notes

    * `binary_checksum` (`string`): Binary ID of the worker who completed this task
      Deprecated. Replaced with `deployment_version`.
    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): The deployment that completed this task. May or may not be set for unversioned workers,
      depending on whether a value is sent by the SDK. This value updates workflow execution's
      `versioning_info.deployment`.
      Deprecated. Replaced with `deployment_version`.
    * `deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The Worker Deployment Version that completed this task. Must be set if `versioning_behavior`
      is set. This value updates workflow execution's `versioning_info.deployment_version`.
    * `sdk_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata`): Data the SDK wishes to record for itself, but server need not interpret, and does not
      directly impact workflow state.
    * `versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior`): Versioning behavior sent by the worker that completed this task for this particular workflow
      execution. UNSPECIFIED means the task was completed by an unversioned worker. This value
      updates workflow execution's `versioning_info.behavior`.
    * `worker_deployment_name` (`string`): The name of Worker Deployment that completed this task. Must be set if `versioning_behavior`
      is set. This value updates workflow execution's `worker_deployment_name`.
    * `worker_deployment_version` (`string`): The Worker Deployment Version that completed this task. Must be set if `versioning_behavior`
      is set. This value updates workflow execution's `versioning_info.version`.
      Deprecated. Replaced with `deployment_version`.
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this workflow task. If present, the `build_id` field
      within is also used as `binary_checksum`, which may be omitted in that case (it may also be
      populated to preserve compatibility).
      Deprecated. Use `deployment_version` and `versioning_behavior` instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"
  field :identity, 3, type: :string
  field :binary_checksum, 4, type: :string, json_name: "binaryChecksum", deprecated: true

  field :worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true

  field :sdk_metadata, 6,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata,
    json_name: "sdkMetadata"

  field :metering_metadata, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata,
    json_name: "meteringMetadata"

  field :deployment, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :versioning_behavior, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    json_name: "versioningBehavior",
    enum: true

  field :worker_deployment_version, 9,
    type: :string,
    json_name: "workerDeploymentVersion",
    deprecated: true

  field :worker_deployment_name, 10, type: :string, json_name: "workerDeploymentName"

  field :deployment_version, 11,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
end
