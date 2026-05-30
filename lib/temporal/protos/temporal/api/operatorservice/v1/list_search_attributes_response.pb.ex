defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse do
  @moduledoc """
  Automatically generated module for ListSearchAttributesResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`custom_attributes`** | `Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.CustomAttributesEntry` | Mapping between custom (user-registered) search attribute name to its IndexedValueType. |
  | 3 | **`storage_schema`** | `Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.StorageSchemaEntry` | Mapping from the attribute name to the visibility storage native type. |
  | 2 | **`system_attributes`** | `Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.SystemAttributesEntry` | Mapping between system (predefined) search attribute name to its IndexedValueType. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :custom_attributes, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.CustomAttributesEntry,
    json_name: "customAttributes",
    map: true

  field :system_attributes, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.SystemAttributesEntry,
    json_name: "systemAttributes",
    map: true

  field :storage_schema, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.StorageSchemaEntry,
    json_name: "storageSchema",
    map: true
end
