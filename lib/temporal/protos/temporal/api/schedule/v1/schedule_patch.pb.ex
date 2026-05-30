defmodule Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch do
  @moduledoc """
  Automatically generated module for SchedulePatch

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`backfill_request`** | `Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest` | If set, runs though the specified time period(s) and takes actions as if that time |
  | 3 | **`pause`** | `string` | If set, change the state to paused or unpaused (respectively) and set the |
  | 1 | **`trigger_immediately`** | `Temporal.Protos.Temporal.Api.Schedule.V1.TriggerImmediatelyRequest` | If set, trigger one action immediately. |
  | 4 | **`unpause`** | `string` |  |

  ### Additional Notes

    * `backfill_request` (`Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest`): If set, runs though the specified time period(s) and takes actions as if that time
      passed by right now, all at once. The overlap policy can be overridden for the
      scope of the backfill.
    * `pause` (`string`): If set, change the state to paused or unpaused (respectively) and set the
      notes field to the value of the string.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :trigger_immediately, 1,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.TriggerImmediatelyRequest,
    json_name: "triggerImmediately"

  field :backfill_request, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest,
    json_name: "backfillRequest"

  field :pause, 3, type: :string
  field :unpause, 4, type: :string
end
