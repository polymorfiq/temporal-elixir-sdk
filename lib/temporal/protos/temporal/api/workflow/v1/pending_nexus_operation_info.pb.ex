defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingNexusOperationInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:endpoint, 1, type: :string)
  field(:service, 2, type: :string)
  field(:operation, 3, type: :string)
  field(:operation_id, 4, type: :string, json_name: "operationId", deprecated: true)

  field(:schedule_to_close_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:scheduled_time, 6, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")

  field(:state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState,
    enum: true
  )

  field(:attempt, 8, type: :int32)

  field(:last_attempt_complete_time, 9,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:last_attempt_failure, 10,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"
  )

  field(:next_attempt_schedule_time, 11,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:cancellation_info, 12,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.NexusOperationCancellationInfo,
    json_name: "cancellationInfo"
  )

  field(:scheduled_event_id, 13, type: :int64, json_name: "scheduledEventId")
  field(:blocked_reason, 14, type: :string, json_name: "blockedReason")
  field(:operation_token, 15, type: :string, json_name: "operationToken")

  field(:schedule_to_start_timeout, 16,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 17,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )
end
