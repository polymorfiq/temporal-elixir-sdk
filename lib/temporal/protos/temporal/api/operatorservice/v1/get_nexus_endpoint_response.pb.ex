defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.GetNexusEndpointResponse do
  @moduledoc """
  Automatically generated module for GetNexusEndpointResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`endpoint`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :endpoint, 1, type: Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint
end
