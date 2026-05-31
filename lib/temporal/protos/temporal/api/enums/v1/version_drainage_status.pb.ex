defmodule Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:VERSION_DRAINAGE_STATUS_UNSPECIFIED, 0)
  field(:VERSION_DRAINAGE_STATUS_DRAINING, 1)
  field(:VERSION_DRAINAGE_STATUS_DRAINED, 2)
end
