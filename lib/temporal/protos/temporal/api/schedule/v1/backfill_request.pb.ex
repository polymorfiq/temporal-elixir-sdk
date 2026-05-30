defmodule Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest do
  @moduledoc """
  Automatically generated module for BackfillRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`end_time`** | `Google.Protobuf.Timestamp` |  |
  | 3 | **`overlap_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy` | If set, override overlap policy for this request. |
  | 1 | **`start_time`** | `Google.Protobuf.Timestamp` | Time range to evaluate schedule in. Currently, this time range is |

  ### Additional Notes

    * `start_time` (`Google.Protobuf.Timestamp`): Time range to evaluate schedule in. Currently, this time range is
      exclusive on start_time and inclusive on end_time. (This is admittedly
      counterintuitive and it may change in the future, so to be safe, use a
      start time strictly before a scheduled time.) Also note that an action
      nominally scheduled in the interval but with jitter that pushes it after
      end_time will not be included.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :start_time, 1, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :end_time, 2, type: Google.Protobuf.Timestamp, json_name: "endTime"

  field :overlap_policy, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true
end
