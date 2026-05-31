defmodule Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:callback, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Callback)
  field(:trigger, 2, type: Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.Trigger)
  field(:registration_time, 3, type: Google.Protobuf.Timestamp, json_name: "registrationTime")
  field(:state, 4, type: Temporal.Protos.Temporal.Api.Enums.V1.CallbackState, enum: true)
  field(:attempt, 5, type: :int32)

  field(:last_attempt_complete_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:last_attempt_failure, 7,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"
  )

  field(:next_attempt_schedule_time, 8,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:blocked_reason, 9, type: :string, json_name: "blockedReason")
end
