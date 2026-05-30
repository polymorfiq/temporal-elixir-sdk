defmodule Temporal.Protos.Temporal.Api.Workflow.V1.NexusOperationCancellationInfo do
  @moduledoc """
  NexusOperationCancellationInfo contains the state of a nexus operation cancellation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`attempt`** | `int32` | The number of attempts made to deliver the cancel operation request. |
  | 7 | **`blocked_reason`** | `string` | If the state is BLOCKED, blocked reason provides additional information. |
  | 4 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last attempt completed. |
  | 5 | **`last_attempt_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The last attempt's failure, if any. |
  | 6 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next attempt is scheduled. |
  | 1 | **`requested_time`** | `Google.Protobuf.Timestamp` | The time when cancellation was requested. |
  | 2 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationCancellationState` |  |

  ### Additional Notes

    * `attempt` (`int32`): The number of attempts made to deliver the cancel operation request.
      This number represents a minimum bound since the attempt is incremented after the request completes.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :requested_time, 1, type: Google.Protobuf.Timestamp, json_name: "requestedTime"

  field :state, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationCancellationState,
    enum: true

  field :attempt, 3, type: :int32

  field :last_attempt_complete_time, 4,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :last_attempt_failure, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"

  field :next_attempt_schedule_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :blocked_reason, 7, type: :string, json_name: "blockedReason"
end
