defmodule Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:entries, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata.EntriesEntry,
    map: true
  )
end
