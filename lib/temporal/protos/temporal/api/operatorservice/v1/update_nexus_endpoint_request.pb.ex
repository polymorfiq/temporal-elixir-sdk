defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.UpdateNexusEndpointRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:id, 1, type: :string)
  field(:version, 2, type: :int64)
  field(:spec, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec)
end
