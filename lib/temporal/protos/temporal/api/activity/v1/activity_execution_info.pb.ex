defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:activity_id, 1, type: :string, json_name: "activityId")
  field(:run_id, 2, type: :string, json_name: "runId")

  field(:activity_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:status, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus,
    enum: true
  )

  field(:run_state, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState,
    json_name: "runState",
    enum: true
  )

  field(:task_queue, 6, type: :string, json_name: "taskQueue")

  field(:schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout")

  field(:retry_policy, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:heartbeat_details, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "heartbeatDetails"
  )

  field(:last_heartbeat_time, 13, type: Google.Protobuf.Timestamp, json_name: "lastHeartbeatTime")
  field(:last_started_time, 14, type: Google.Protobuf.Timestamp, json_name: "lastStartedTime")
  field(:attempt, 15, type: :int32)
  field(:execution_duration, 16, type: Google.Protobuf.Duration, json_name: "executionDuration")
  field(:schedule_time, 17, type: Google.Protobuf.Timestamp, json_name: "scheduleTime")
  field(:expiration_time, 18, type: Google.Protobuf.Timestamp, json_name: "expirationTime")
  field(:close_time, 19, type: Google.Protobuf.Timestamp, json_name: "closeTime")

  field(:last_failure, 20,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"
  )

  field(:last_worker_identity, 21, type: :string, json_name: "lastWorkerIdentity")

  field(:current_retry_interval, 22,
    type: Google.Protobuf.Duration,
    json_name: "currentRetryInterval"
  )

  field(:last_attempt_complete_time, 23,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:next_attempt_schedule_time, 24,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:last_deployment_version, 25,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "lastDeploymentVersion"
  )

  field(:priority, 26, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
  field(:state_transition_count, 27, type: :int64, json_name: "stateTransitionCount")
  field(:state_size_bytes, 28, type: :int64, json_name: "stateSizeBytes")

  field(:search_attributes, 29,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:header, 30, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:user_metadata, 31,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:canceled_reason, 32, type: :string, json_name: "canceledReason")
  field(:links, 33, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
  field(:total_heartbeat_count, 34, type: :int64, json_name: "totalHeartbeatCount")
  field(:sdk_name, 35, type: :string, json_name: "sdkName")
  field(:sdk_version, 36, type: :string, json_name: "sdkVersion")
end
