defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:worker, 1, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.Worker, oneof: 0)

  field(:external, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.External,
    oneof: 0
  )
end
