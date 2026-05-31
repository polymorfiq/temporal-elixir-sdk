defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.CreateNexusEndpointRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:spec, 1, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec)
end
