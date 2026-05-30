defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveSearchAttributesRequest do
  @moduledoc """
  Automatically generated module for RemoveSearchAttributesRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`namespace`** | `string` |  |
  | 1 | **`search_attributes`** | `string` | Search attribute names to delete. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :search_attributes, 1, repeated: true, type: :string, json_name: "searchAttributes"
  field :namespace, 2, type: :string
end
