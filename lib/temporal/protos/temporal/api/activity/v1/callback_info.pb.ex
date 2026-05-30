defmodule Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo do
  @moduledoc """
  CallbackInfo contains the state of an attached activity callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`info`** | `Temporal.Protos.Temporal.Api.Callback.V1.CallbackInfo` | Common callback info. |
  | 1 | **`trigger`** | `Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.Trigger` | Trigger for this callback. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :trigger, 1, type: Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.Trigger
  field :info, 2, type: Temporal.Protos.Temporal.Api.Callback.V1.CallbackInfo
end
