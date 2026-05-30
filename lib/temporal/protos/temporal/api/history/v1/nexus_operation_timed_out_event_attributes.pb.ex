defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationTimedOutEventAttributes do
  @moduledoc """
  Nexus operation timed out.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Failure details. A NexusOperationFailureInfo wrapping a CanceledFailureInfo. |
  | 3 | **`request_id`** | `string` | The request ID allocated at schedule time. |
  | 1 | **`scheduled_event_id`** | `int64` | The ID of the `NEXUS_OPERATION_SCHEDULED` event. Uniquely identifies this operation. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :request_id, 3, type: :string, json_name: "requestId"
end
