defmodule Temporal.Protos.Temporal.Api.Callback.V1.CallbackInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:callback, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Callback)
  field(:registration_time, 2, type: Google.Protobuf.Timestamp, json_name: "registrationTime")
  field(:state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.CallbackState, enum: true)
  field(:attempt, 4, type: :int32)

  field(:last_attempt_complete_time, 5,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"
  )

  field(:last_attempt_failure, 6,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"
  )

  field(:next_attempt_schedule_time, 7,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"
  )

  field(:blocked_reason, 8, type: :string, json_name: "blockedReason")
end
