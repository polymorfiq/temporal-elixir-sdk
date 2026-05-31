defmodule Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:VERSIONING_BEHAVIOR_UNSPECIFIED, 0)
  field(:VERSIONING_BEHAVIOR_PINNED, 1)
  field(:VERSIONING_BEHAVIOR_AUTO_UPGRADE, 2)
end
