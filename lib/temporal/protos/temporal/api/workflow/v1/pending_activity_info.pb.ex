defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:assigned_build_id, 0)

  field(:activity_id, 1, type: :string, json_name: "activityId")

  field(:activity_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState, enum: true)

  field(:heartbeat_details, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "heartbeatDetails"
  )

  field(:last_heartbeat_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastHeartbeatTime")
  field(:last_started_time, 6, type: Google.Protobuf.Timestamp, json_name: "lastStartedTime")
  field(:attempt, 7, type: :int32)
  field(:maximum_attempts, 8, type: :int32, json_name: "maximumAttempts")
  field(:scheduled_time, 9, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")
  field(:expiration_time, 10, type: Google.Protobuf.Timestamp, json_name: "expirationTime")

  field(:last_failure, 11,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"
  )

  field(:last_worker_identity, 12, type: :string, json_name: "lastWorkerIdentity")

  field(:use_workflow_build_id, 13,
    type: Google.Protobuf.Empty,
    json_name: "useWorkflowBuildId",
    oneof: 0,
    deprecated: true
  )

  field(:last_independently_assigned_build_id, 14,
    type: :string,
    json_name: "lastIndependentlyAssignedBuildId",
    oneof: 0,
    deprecated: true
  )

  field(:last_worker_version_stamp, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "lastWorkerVersionStamp",
    deprecated: true
  )

  field(:current_retry_interval, 16,
    type: Google.Protobuf.Duration,
    json_name: "currentRetryInterval"
  )

  field(:last_attempt_complete_time, 17,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:next_attempt_schedule_time, 18,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:paused, 19, type: :bool)

  field(:last_deployment, 20,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    json_name: "lastDeployment",
    deprecated: true
  )

  field(:last_worker_deployment_version, 21,
    type: :string,
    json_name: "lastWorkerDeploymentVersion",
    deprecated: true
  )

  field(:last_deployment_version, 25,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "lastDeploymentVersion"
  )

  field(:priority, 22, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:pause_info, 23,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo,
    json_name: "pauseInfo"
  )

  field(:activity_options, 24,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
  )
end
