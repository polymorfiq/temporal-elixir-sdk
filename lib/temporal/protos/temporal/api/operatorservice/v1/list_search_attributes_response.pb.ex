defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:custom_attributes, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.CustomAttributesEntry,
    json_name: "customAttributes",
    map: true
  )

  field(:system_attributes, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.SystemAttributesEntry,
    json_name: "systemAttributes",
    map: true
  )

  field(:storage_schema, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.StorageSchemaEntry,
    json_name: "storageSchema",
    map: true
  )
end
