defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:description, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
  field(:target, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget)
end
