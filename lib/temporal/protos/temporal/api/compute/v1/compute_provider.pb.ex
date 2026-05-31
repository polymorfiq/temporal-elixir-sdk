defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
  field(:nexus_endpoint, 10, type: :string, json_name: "nexusEndpoint")
end
