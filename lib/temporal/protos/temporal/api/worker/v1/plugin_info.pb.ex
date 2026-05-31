defmodule Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:version, 2, type: :string)
end
