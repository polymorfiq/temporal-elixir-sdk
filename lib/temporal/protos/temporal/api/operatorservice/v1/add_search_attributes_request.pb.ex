defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest do
  @moduledoc """
  (-- Search Attribute --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`namespace`** | `string` |  |
  | 1 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest.SearchAttributesEntry` | Mapping between search attribute name and its IndexedValueType. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :search_attributes, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest.SearchAttributesEntry,
    json_name: "searchAttributes",
    map: true

  field :namespace, 2, type: :string
end
