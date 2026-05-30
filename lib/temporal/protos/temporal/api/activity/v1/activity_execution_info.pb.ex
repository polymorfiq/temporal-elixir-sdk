defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionInfo do
  @moduledoc """
  Information about a standalone activity.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_id`** | `string` | Unique identifier of this activity within its namespace along with run ID (below). |
  | 3 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` | The type of the activity, a string that maps to a registered activity on a worker. |
  | 15 | **`attempt`** | `int32` | The attempt this activity is currently on. Incremented each time a new attempt is scheduled. |
  | 32 | **`canceled_reason`** | `string` | Set if activity cancelation was requested. |
  | 19 | **`close_time`** | `Google.Protobuf.Timestamp` | Time when the activity transitioned to a closed state. |
  | 22 | **`current_retry_interval`** | `Google.Protobuf.Duration` | Time from the last attempt failure to the next activity retry. |
  | 16 | **`execution_duration`** | `Google.Protobuf.Duration` | How long this activity has been running for, including all attempts and backoff between attempts. |
  | 18 | **`expiration_time`** | `Google.Protobuf.Timestamp` | Scheduled time + schedule to close timeout. |
  | 30 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 12 | **`heartbeat_details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Details provided in the last recorded activity heartbeat. |
  | 10 | **`heartbeat_timeout`** | `Google.Protobuf.Duration` | Maximum permitted time between successful worker heartbeats. |
  | 23 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last activity attempt completed. If activity has not been completed yet, it will be null. |
  | 25 | **`last_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The Worker Deployment Version this activity was dispatched to most recently. |
  | 20 | **`last_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Failure details from the last failed attempt. |
  | 13 | **`last_heartbeat_time`** | `Google.Protobuf.Timestamp` | Time the last heartbeat was recorded. |
  | 14 | **`last_started_time`** | `Google.Protobuf.Timestamp` | Time the last attempt was started. |
  | 21 | **`last_worker_identity`** | `string` |  |
  | 33 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to related entities, such as the entity that started this activity. |
  | 24 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next activity attempt will be scheduled. |
  | 26 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. |
  | 11 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | The retry policy for the activity. Will never exceed `schedule_to_close_timeout`. |
  | 2 | **`run_id`** | `string` |  |
  | 5 | **`run_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState` | More detailed breakdown of ACTIVITY_EXECUTION_STATUS_RUNNING. |
  | 17 | **`schedule_time`** | `Google.Protobuf.Timestamp` | Time the activity was originally scheduled via a StartActivityExecution request. |
  | 7 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Indicates how long the caller is willing to wait for an activity completion. Limits how long |
  | 8 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Limits time an activity task can stay in a task queue before a worker picks it up. This |
  | 35 | **`sdk_name`** | `string` | The name of the SDK of the worker that most recently picked up an attempt of this activity. |
  | 36 | **`sdk_version`** | `string` | The version of the SDK of the worker that most recently picked up an attempt of this activity. |
  | 29 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 9 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Maximum time a single activity attempt is allowed to execute after being picked up by a worker. This |
  | 28 | **`state_size_bytes`** | `int64` | Updated once on scheduled and once on terminal status. |
  | 27 | **`state_transition_count`** | `int64` | Incremented each time the activity's state is mutated in persistence. |
  | 4 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus` | A general status for this activity, indicates whether it is currently running or in one of the terminal statuses. |
  | 6 | **`task_queue`** | `string` |  |
  | 34 | **`total_heartbeat_count`** | `int64` | Total number of heartbeats recorded across all attempts of this activity, including retries. |
  | 31 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata for use by user interfaces to display the fixed as-of-start summary and details of the activity. |

  ### Additional Notes

    * `current_retry_interval` (`Google.Protobuf.Duration`): Time from the last attempt failure to the next activity retry.
      If the activity is currently running, this represents the next retry interval in case the attempt fails.
      If activity is currently backing off between attempt, this represents the current retry interval.
      If there is no next retry allowed, this field will be null.
      This interval is typically calculated from the specified retry policy, but may be modified if an activity fails
      with a retryable application failure specifying a retry delay.
    * `last_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The Worker Deployment Version this activity was dispatched to most recently.
      If nil, the activity has not yet been dispatched or was last dispatched to an unversioned worker.
    * `next_attempt_schedule_time` (`Google.Protobuf.Timestamp`): The time when the next activity attempt will be scheduled.
      If activity is currently scheduled or started, this field will be null.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Indicates how long the caller is willing to wait for an activity completion. Limits how long
      retries will be attempted.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Limits time an activity task can stay in a task queue before a worker picks it up. This
      timeout is always non retryable, as all a retry would achieve is to put it back into the same
      queue. Defaults to `schedule_to_close_timeout`.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `sdk_name` (`string`): The name of the SDK of the worker that most recently picked up an attempt of this activity.
      Overwritten on each new attempt. Empty if unknown.
    * `sdk_version` (`string`): The version of the SDK of the worker that most recently picked up an attempt of this activity.
      Overwritten on each new attempt. Empty if unknown.
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Maximum time a single activity attempt is allowed to execute after being picked up by a worker. This
      timeout is always retryable.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :activity_id, 1, type: :string, json_name: "activityId"
  field :run_id, 2, type: :string, json_name: "runId"

  field :activity_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :status, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus,
    enum: true

  field :run_state, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState,
    json_name: "runState",
    enum: true

  field :task_queue, 6, type: :string, json_name: "taskQueue"

  field :schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout"

  field :retry_policy, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :heartbeat_details, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "heartbeatDetails"

  field :last_heartbeat_time, 13, type: Google.Protobuf.Timestamp, json_name: "lastHeartbeatTime"
  field :last_started_time, 14, type: Google.Protobuf.Timestamp, json_name: "lastStartedTime"
  field :attempt, 15, type: :int32
  field :execution_duration, 16, type: Google.Protobuf.Duration, json_name: "executionDuration"
  field :schedule_time, 17, type: Google.Protobuf.Timestamp, json_name: "scheduleTime"
  field :expiration_time, 18, type: Google.Protobuf.Timestamp, json_name: "expirationTime"
  field :close_time, 19, type: Google.Protobuf.Timestamp, json_name: "closeTime"

  field :last_failure, 20,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"

  field :last_worker_identity, 21, type: :string, json_name: "lastWorkerIdentity"

  field :current_retry_interval, 22,
    type: Google.Protobuf.Duration,
    json_name: "currentRetryInterval"

  field :last_attempt_complete_time, 23,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :next_attempt_schedule_time, 24,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :last_deployment_version, 25,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "lastDeploymentVersion"

  field :priority, 26, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
  field :state_transition_count, 27, type: :int64, json_name: "stateTransitionCount"
  field :state_size_bytes, 28, type: :int64, json_name: "stateSizeBytes"

  field :search_attributes, 29,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :header, 30, type: Temporal.Protos.Temporal.Api.Common.V1.Header

  field :user_metadata, 31,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :canceled_reason, 32, type: :string, json_name: "canceledReason"
  field :links, 33, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
  field :total_heartbeat_count, 34, type: :int64, json_name: "totalHeartbeatCount"
  field :sdk_name, 35, type: :string, json_name: "sdkName"
  field :sdk_version, 36, type: :string, json_name: "sdkVersion"
end
