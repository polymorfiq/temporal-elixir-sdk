defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNexusEndpointRequest do
  @moduledoc """
  Automatically generated module for DeleteNexusEndpointRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`id`** | `string` | Server-generated unique endpoint ID. |
  | 2 | **`version`** | `int64` | Data version for this endpoint. Must match current version. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :id, 1, type: :string
  field :version, 2, type: :int64
end
