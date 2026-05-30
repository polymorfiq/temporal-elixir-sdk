defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest.SearchAttributesEntry do
  @moduledoc """
  (-- Search Attribute --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Mapping between search attribute name and its IndexedValueType. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Enums.V1.IndexedValueType` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.IndexedValueType, enum: true
end
