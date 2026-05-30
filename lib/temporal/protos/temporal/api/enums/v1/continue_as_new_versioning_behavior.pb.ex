defmodule Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :CONTINUE_AS_NEW_VERSIONING_BEHAVIOR_UNSPECIFIED, 0
  field :CONTINUE_AS_NEW_VERSIONING_BEHAVIOR_AUTO_UPGRADE, 1
  field :CONTINUE_AS_NEW_VERSIONING_BEHAVIOR_USE_RAMPING_VERSION, 2
end
