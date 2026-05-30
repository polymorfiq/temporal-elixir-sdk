defmodule Temporal.Protos.Temporal.Api.History.V1.TimerFiredEventAttributes do
  @moduledoc """
  Automatically generated module for TimerFiredEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`started_event_id`** | `int64` | The id of the `TIMER_STARTED` event itself |
  | 1 | **`timer_id`** | `string` | Will match the `timer_id` from `TIMER_STARTED` event for this timer |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :timer_id, 1, type: :string, json_name: "timerId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"
end
