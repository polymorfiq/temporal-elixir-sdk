defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.UpdateNexusEndpointRequest do
  @moduledoc """
  Automatically generated module for UpdateNexusEndpointRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`id`** | `string` | Server-generated unique endpoint ID. |
  | 3 | **`spec`** | `Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec` |  |
  | 2 | **`version`** | `int64` | Data version for this endpoint. Must match current version. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :id, 1, type: :string
  field :version, 2, type: :int64
  field :spec, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec
end
