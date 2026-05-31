defmodule Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:trigger, 1, type: Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo.Trigger)
  field(:info, 2, type: Temporal.Protos.Temporal.Api.Callback.V1.CallbackInfo)
end
