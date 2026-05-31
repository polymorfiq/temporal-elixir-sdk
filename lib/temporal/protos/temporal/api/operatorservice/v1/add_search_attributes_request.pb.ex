defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:search_attributes, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest.SearchAttributesEntry,
    json_name: "searchAttributes",
    map: true
  )

  field(:namespace, 2, type: :string)
end
