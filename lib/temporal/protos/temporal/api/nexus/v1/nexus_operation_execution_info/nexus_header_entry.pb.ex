defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo.NexusHeaderEntry do
  @moduledoc """
  Full current state of a standalone Nexus operation, as of the time of the request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Unique identifier of this Nexus operation within its namespace along with run ID (below). |
  | 2 | **`value`** | `string` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
