defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse.StorageSchemaEntry do
  @moduledoc """
  Automatically generated module for StorageSchemaEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Mapping between custom (user-registered) search attribute name to its IndexedValueType. |
  | 2 | **`value`** | `string` | Mapping between system (predefined) search attribute name to its IndexedValueType. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
