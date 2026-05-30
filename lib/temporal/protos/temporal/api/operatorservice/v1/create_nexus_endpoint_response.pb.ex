defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.CreateNexusEndpointResponse do
  @moduledoc """
  Automatically generated module for CreateNexusEndpointResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`endpoint`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint` | Data post acceptance. Can be used to issue additional updates to this record. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :endpoint, 1, type: Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint
end
