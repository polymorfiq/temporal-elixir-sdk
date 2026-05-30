defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationScheduledEventAttributes.NexusHeaderEntry do
  @moduledoc """
  Event marking that an operation was scheduled by a workflow via the ScheduleNexusOperation command.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Endpoint name, must exist in the endpoint registry. |
  | 2 | **`value`** | `string` | Service name. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
