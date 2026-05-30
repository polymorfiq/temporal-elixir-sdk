defmodule Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes.NexusHeaderEntry do
  @moduledoc """
  Automatically generated module for NexusHeaderEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Endpoint name, must exist in the endpoint registry or this command will fail. |
  | 2 | **`value`** | `string` | Service name. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
