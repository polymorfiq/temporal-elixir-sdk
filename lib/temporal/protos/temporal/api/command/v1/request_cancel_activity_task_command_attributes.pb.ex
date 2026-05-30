defmodule Temporal.Protos.Temporal.Api.Command.V1.RequestCancelActivityTaskCommandAttributes do
  @moduledoc """
  Automatically generated module for RequestCancelActivityTaskCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scheduled_event_id`** | `int64` | The `ACTIVITY_TASK_SCHEDULED` event id for the activity being cancelled. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
end
