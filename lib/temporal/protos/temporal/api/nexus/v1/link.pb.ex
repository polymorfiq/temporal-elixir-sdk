defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Link do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:url, 1, type: :string)
  field(:type, 2, type: :string)
end
