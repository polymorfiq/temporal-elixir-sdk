defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Sync do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:payload, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
  field(:links, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Link)
end
