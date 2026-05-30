defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskTimedOutEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskTimedOutEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | If this activity had failed, was retried, and then timed out, that failure is stored as the |
  | 4 | **`retry_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.RetryState` |  |
  | 2 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this timeout corresponds to |
  | 3 | **`started_event_id`** | `int64` | The id of the `ACTIVITY_TASK_STARTED` event this timeout corresponds to |

  ### Additional Notes

    * `failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): If this activity had failed, was retried, and then timed out, that failure is stored as the
      `cause` in here.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :scheduled_event_id, 2, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 3, type: :int64, json_name: "startedEventId"

  field :retry_state, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
end
