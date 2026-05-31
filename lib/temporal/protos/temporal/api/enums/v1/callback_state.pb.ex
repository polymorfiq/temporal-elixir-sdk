defmodule Temporal.Protos.Temporal.Api.Enums.V1.CallbackState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:CALLBACK_STATE_UNSPECIFIED, 0)
  field(:CALLBACK_STATE_STANDBY, 1)
  field(:CALLBACK_STATE_SCHEDULED, 2)
  field(:CALLBACK_STATE_BACKING_OFF, 3)
  field(:CALLBACK_STATE_FAILED, 4)
  field(:CALLBACK_STATE_SUCCEEDED, 5)
  field(:CALLBACK_STATE_BLOCKED, 6)
end
