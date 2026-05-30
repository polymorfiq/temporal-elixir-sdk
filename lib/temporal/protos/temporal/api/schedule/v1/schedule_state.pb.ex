defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleState do
  @moduledoc """
  Automatically generated module for ScheduleState

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`limited_actions`** | `bool` | If limited_actions is true, decrement remaining_actions after each |
  | 1 | **`notes`** | `string` | Informative human-readable message with contextual notes, e.g. the reason |
  | 2 | **`paused`** | `bool` | If true, do not take any actions based on the schedule spec. |
  | 4 | **`remaining_actions`** | `int64` |  |

  ### Additional Notes

    * `limited_actions` (`bool`): If limited_actions is true, decrement remaining_actions after each
      action, and do not take any more scheduled actions if remaining_actions
      is zero. Actions may still be taken by explicit request (i.e. trigger
      immediately or backfill). Skipped actions (due to overlap policy) do not
      count against remaining actions.
      If a schedule has no more remaining actions, then the schedule will be
      subject to automatic deletion (after several days).
    * `notes` (`string`): Informative human-readable message with contextual notes, e.g. the reason
      a schedule is paused. The system may overwrite this message on certain
      conditions, e.g. when pause-on-failure happens.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :notes, 1, type: :string
  field :paused, 2, type: :bool
  field :limited_actions, 3, type: :bool, json_name: "limitedActions"
  field :remaining_actions, 4, type: :int64, json_name: "remainingActions"
end
