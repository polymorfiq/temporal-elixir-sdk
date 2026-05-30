defmodule Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo do
  @moduledoc """
  CallbackInfo contains the state of an attached workflow callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`attempt`** | `int32` | The number of attempts made to deliver the callback. |
  | 9 | **`blocked_reason`** | `string` | If the state is BLOCKED, blocked reason provides additional information. |
  | 1 | **`callback`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Information on how this callback should be invoked (e.g. its URL and type). |
  | 6 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last attempt completed. |
  | 7 | **`last_attempt_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The last attempt's failure, if any. |
  | 8 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next attempt is scheduled. |
  | 3 | **`registration_time`** | `Google.Protobuf.Timestamp` | The time when the callback was registered. |
  | 4 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.CallbackState` |  |
  | 2 | **`trigger`** | `Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.Trigger` | Trigger for this callback. |

  ### Additional Notes

    * `attempt` (`int32`): The number of attempts made to deliver the callback.
      This number represents a minimum bound since the attempt is incremented after the callback request completes.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :callback, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Callback
  field :trigger, 2, type: Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.Trigger
  field :registration_time, 3, type: Google.Protobuf.Timestamp, json_name: "registrationTime"
  field :state, 4, type: Temporal.Protos.Temporal.Api.Enums.V1.CallbackState, enum: true
  field :attempt, 5, type: :int32

  field :last_attempt_complete_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :last_attempt_failure, 7,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"

  field :next_attempt_schedule_time, 8,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :blocked_reason, 9, type: :string, json_name: "blockedReason"
end
