defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveSearchAttributesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:search_attributes, 1, repeated: true, type: :string, json_name: "searchAttributes")
  field(:namespace, 2, type: :string)
end
