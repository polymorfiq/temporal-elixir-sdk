defmodule Temporal.Protos.Google.Api.CustomHttpPattern do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:kind, 1, type: :string)
  field(:path, 2, type: :string)
end
