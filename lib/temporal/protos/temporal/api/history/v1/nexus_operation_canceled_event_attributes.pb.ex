defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationCanceledEventAttributes do
  @moduledoc """
  Nexus operation completed as canceled. May or may not have been due to a cancellation request by the workflow.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Cancellation details. |
  | 3 | **`request_id`** | `string` | The request ID allocated at schedule time. |
  | 1 | **`scheduled_event_id`** | `int64` | The ID of the `NEXUS_OPERATION_SCHEDULED` event. Uniquely identifies this operation. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :request_id, 3, type: :string, json_name: "requestId"
end
