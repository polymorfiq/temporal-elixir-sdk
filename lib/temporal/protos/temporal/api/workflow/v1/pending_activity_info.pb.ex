defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo do
  @moduledoc """
  Automatically generated module for PendingActivityInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_id`** | `string` |  |
  | 24 | **`activity_options`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions` | Current activity options. May be different from the one used to start the activity. |
  | 2 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` |  |
  | 7 | **`attempt`** | `int32` |  |
  | 16 | **`current_retry_interval`** | `Google.Protobuf.Duration` | The time activity will wait until the next retry. |
  | 10 | **`expiration_time`** | `Google.Protobuf.Timestamp` |  |
  | 4 | **`heartbeat_details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 17 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last activity attempt was completed. If activity has not been completed yet then it will be null. |
  | 20 | **`last_deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | The deployment this activity was dispatched to most recently. Present only if the activity |
  | 25 | **`last_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The Worker Deployment Version this activity was dispatched to most recently. |
  | 11 | **`last_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |
  | 5 | **`last_heartbeat_time`** | `Google.Protobuf.Timestamp` |  |
  | 14 | **`last_independently_assigned_build_id`** | `string` | Deprecated. This means the activity is independently versioned and not bound to the build ID of its workflow. |
  | 6 | **`last_started_time`** | `Google.Protobuf.Timestamp` |  |
  | 21 | **`last_worker_deployment_version`** | `string` | The Worker Deployment Version this activity was dispatched to most recently. |
  | 12 | **`last_worker_identity`** | `string` |  |
  | 15 | **`last_worker_version_stamp`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Deprecated. The version stamp of the worker to whom this activity was most recently dispatched |
  | 8 | **`maximum_attempts`** | `int32` |  |
  | 18 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | Next time when activity will be scheduled. |
  | 23 | **`pause_info`** | `Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo` |  |
  | 19 | **`paused`** | `bool` | Indicates if activity is paused. |
  | 22 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. If this message is not present, or any fields are not |
  | 9 | **`scheduled_time`** | `Google.Protobuf.Timestamp` |  |
  | 3 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState` |  |
  | 13 | **`use_workflow_build_id`** | `Google.Protobuf.Empty` | Deprecated. When present, it means this activity is assigned to the build ID of its workflow. |

  ### Additional Notes

    * `current_retry_interval` (`Google.Protobuf.Duration`): The time activity will wait until the next retry.
      If activity is currently running it will be next retry interval if activity failed.
      If activity is currently waiting it will be current retry interval.
      If there will be no retry it will be null.
    * `last_deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): The deployment this activity was dispatched to most recently. Present only if the activity
      was dispatched to a versioned worker.
      Deprecated. Use `last_deployment_version`.
    * `last_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The Worker Deployment Version this activity was dispatched to most recently.
      If nil, the activity has not yet been dispatched or was last dispatched to an unversioned worker.
    * `last_independently_assigned_build_id` (`string`): Deprecated. This means the activity is independently versioned and not bound to the build ID of its workflow.
      The activity will use the build id in this field instead.
      If the task fails and is scheduled again, the assigned build ID may change according to the latest versioning
      rules.
    * `last_worker_deployment_version` (`string`): The Worker Deployment Version this activity was dispatched to most recently.
      Deprecated. Use `last_deployment_version`.
    * `last_worker_version_stamp` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Deprecated. The version stamp of the worker to whom this activity was most recently dispatched
      This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `next_attempt_schedule_time` (`Google.Protobuf.Timestamp`): Next time when activity will be scheduled.
      If activity is currently scheduled or started it will be null.
    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority metadata. If this message is not present, or any fields are not
      present, they inherit the values from the workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :assigned_build_id, 0

  field :activity_id, 1, type: :string, json_name: "activityId"

  field :activity_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState, enum: true

  field :heartbeat_details, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "heartbeatDetails"

  field :last_heartbeat_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastHeartbeatTime"
  field :last_started_time, 6, type: Google.Protobuf.Timestamp, json_name: "lastStartedTime"
  field :attempt, 7, type: :int32
  field :maximum_attempts, 8, type: :int32, json_name: "maximumAttempts"
  field :scheduled_time, 9, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"
  field :expiration_time, 10, type: Google.Protobuf.Timestamp, json_name: "expirationTime"

  field :last_failure, 11,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"

  field :last_worker_identity, 12, type: :string, json_name: "lastWorkerIdentity"

  field :use_workflow_build_id, 13,
    type: Google.Protobuf.Empty,
    json_name: "useWorkflowBuildId",
    oneof: 0,
    deprecated: true

  field :last_independently_assigned_build_id, 14,
    type: :string,
    json_name: "lastIndependentlyAssignedBuildId",
    oneof: 0,
    deprecated: true

  field :last_worker_version_stamp, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "lastWorkerVersionStamp",
    deprecated: true

  field :current_retry_interval, 16,
    type: Google.Protobuf.Duration,
    json_name: "currentRetryInterval"

  field :last_attempt_complete_time, 17,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :next_attempt_schedule_time, 18,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :paused, 19, type: :bool

  field :last_deployment, 20,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    json_name: "lastDeployment",
    deprecated: true

  field :last_worker_deployment_version, 21,
    type: :string,
    json_name: "lastWorkerDeploymentVersion",
    deprecated: true

  field :last_deployment_version, 25,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "lastDeploymentVersion"

  field :priority, 22, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :pause_info, 23,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo,
    json_name: "pauseInfo"

  field :activity_options, 24,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
end
