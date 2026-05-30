defmodule Temporal.Protos.Temporal.Api.Callback.V1.CallbackInfo do
  @moduledoc """
  Common callback information. Specific CallbackInfo messages should embed this and may include additional fields.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`attempt`** | `int32` | The number of attempts made to deliver the callback. |
  | 8 | **`blocked_reason`** | `string` | If the state is BLOCKED, blocked reason provides additional information. |
  | 1 | **`callback`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Information on how this callback should be invoked (e.g. its URL and type). |
  | 5 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last attempt completed. |
  | 6 | **`last_attempt_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The last attempt's failure, if any. |
  | 7 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next attempt is scheduled. |
  | 2 | **`registration_time`** | `Google.Protobuf.Timestamp` | The time when the callback was registered. |
  | 3 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.CallbackState` | The current state of the callback. |

  ### Additional Notes

    * `attempt` (`int32`): The number of attempts made to deliver the callback.
      This number represents a minimum bound since the attempt is incremented after the callback request completes.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :callback, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Callback
  field :registration_time, 2, type: Google.Protobuf.Timestamp, json_name: "registrationTime"
  field :state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.CallbackState, enum: true
  field :attempt, 4, type: :int32

  field :last_attempt_complete_time, 5,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :last_attempt_failure, 6,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"

  field :next_attempt_schedule_time, 7,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :blocked_reason, 8, type: :string, json_name: "blockedReason"
end
