defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionRequest.NexusHeaderEntry do
  @moduledoc """
  Automatically generated module for NexusHeaderEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `string` | The identity of the client who initiated this request. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
