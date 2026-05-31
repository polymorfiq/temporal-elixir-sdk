defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionCancellationInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:requested_time, 1, type: Google.Protobuf.Timestamp, json_name: "requestedTime")

  field(:state, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationCancellationState,
    enum: true
  )

  field(:attempt, 3, type: :int32)

  field(:last_attempt_complete_time, 4,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:last_attempt_failure, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"
  )

  field(:next_attempt_schedule_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:blocked_reason, 7, type: :string, json_name: "blockedReason")
  field(:reason, 8, type: :string)
end
