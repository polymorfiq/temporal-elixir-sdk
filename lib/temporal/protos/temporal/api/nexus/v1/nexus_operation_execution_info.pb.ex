defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_id, 1, type: :string, json_name: "operationId")
  field(:run_id, 2, type: :string, json_name: "runId")
  field(:endpoint, 3, type: :string)
  field(:service, 4, type: :string)
  field(:operation, 5, type: :string)

  field(:status, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus,
    enum: true
  )

  field(:state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState,
    enum: true
  )

  field(:schedule_to_close_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:schedule_to_start_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 10,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:attempt, 11, type: :int32)
  field(:schedule_time, 12, type: Google.Protobuf.Timestamp, json_name: "scheduleTime")
  field(:expiration_time, 13, type: Google.Protobuf.Timestamp, json_name: "expirationTime")
  field(:close_time, 14, type: Google.Protobuf.Timestamp, json_name: "closeTime")

  field(:last_attempt_complete_time, 15,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:last_attempt_failure, 16,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"
  )

  field(:next_attempt_schedule_time, 17,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:execution_duration, 18, type: Google.Protobuf.Duration, json_name: "executionDuration")

  field(:cancellation_info, 19,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionCancellationInfo,
    json_name: "cancellationInfo"
  )

  field(:blocked_reason, 20, type: :string, json_name: "blockedReason")
  field(:request_id, 21, type: :string, json_name: "requestId")
  field(:operation_token, 22, type: :string, json_name: "operationToken")
  field(:state_transition_count, 23, type: :int64, json_name: "stateTransitionCount")

  field(:search_attributes, 24,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:nexus_header, 25,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true
  )

  field(:user_metadata, 26,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:links, 27, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
  field(:identity, 28, type: :string)
  field(:state_size_bytes, 29, type: :int64, json_name: "stateSizeBytes")
end
