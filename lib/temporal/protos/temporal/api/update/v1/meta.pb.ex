defmodule Temporal.Protos.Temporal.Api.Update.V1.Meta do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:update_id, 1, type: :string, json_name: "updateId")
  field(:identity, 2, type: :string)
end
