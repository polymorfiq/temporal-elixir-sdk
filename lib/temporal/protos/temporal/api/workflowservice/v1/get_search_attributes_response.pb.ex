defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSearchAttributesResponse do
  @moduledoc """
  Automatically generated module for GetSearchAttributesResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`keys`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSearchAttributesResponse.KeysEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :keys, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSearchAttributesResponse.KeysEntry,
    map: true
end
