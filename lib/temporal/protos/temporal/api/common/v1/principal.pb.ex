defmodule Temporal.Protos.Temporal.Api.Common.V1.Principal do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:name, 2, type: :string)
end
