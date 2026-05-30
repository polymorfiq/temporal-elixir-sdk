defmodule Temporal.Protos.Temporal.Api.Command.V1.RequestCancelNexusOperationCommandAttributes do
  @moduledoc """
  Automatically generated module for RequestCancelNexusOperationCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scheduled_event_id`** | `int64` | The `NEXUS_OPERATION_SCHEDULED` event ID (a unique identifier) for the operation to be canceled. |

  ### Additional Notes

    * `scheduled_event_id` (`int64`): The `NEXUS_OPERATION_SCHEDULED` event ID (a unique identifier) for the operation to be canceled.
      The operation may ignore cancellation and end up with any completion state.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
end
