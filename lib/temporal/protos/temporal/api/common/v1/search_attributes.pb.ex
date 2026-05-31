defmodule Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:indexed_fields, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes.IndexedFieldsEntry,
    json_name: "indexedFields",
    map: true
  )
end
