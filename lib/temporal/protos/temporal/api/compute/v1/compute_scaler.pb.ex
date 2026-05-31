defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
end
