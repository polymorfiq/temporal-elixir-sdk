defmodule Temporal.Protos.Temporal.Api.Command.V1.UpsertWorkflowSearchAttributesCommandAttributes do
  @moduledoc """
  Automatically generated module for UpsertWorkflowSearchAttributesCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :search_attributes, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
end
