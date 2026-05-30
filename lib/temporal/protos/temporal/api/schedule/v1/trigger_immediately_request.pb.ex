defmodule Temporal.Protos.Temporal.Api.Schedule.V1.TriggerImmediatelyRequest do
  @moduledoc """
  Automatically generated module for TriggerImmediatelyRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`overlap_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy` | If set, override overlap policy for this one request. |
  | 2 | **`scheduled_time`** | `Google.Protobuf.Timestamp` | Timestamp used for the identity of the target workflow. |

  ### Additional Notes

    * `scheduled_time` (`Google.Protobuf.Timestamp`): Timestamp used for the identity of the target workflow.
      If not set the default value is the current time.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :overlap_policy, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true

  field :scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"
end
