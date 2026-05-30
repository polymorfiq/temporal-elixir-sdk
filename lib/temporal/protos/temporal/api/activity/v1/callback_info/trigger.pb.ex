defmodule Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.Trigger do
  @moduledoc """
  CallbackInfo contains the state of an attached activity callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_closed`** | `Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.ActivityClosed` | Trigger for this callback. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :activity_closed, 1,
    type: Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.ActivityClosed,
    json_name: "activityClosed",
    oneof: 0
end
