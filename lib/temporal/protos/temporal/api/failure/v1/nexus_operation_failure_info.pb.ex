defmodule Temporal.Protos.Temporal.Api.Failure.V1.NexusOperationFailureInfo do
  @moduledoc """
  Representation of the Temporal SDK NexusOperationError object that is returned to workflow callers.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`endpoint`** | `string` | Endpoint name. |
  | 4 | **`operation`** | `string` | Operation name. |
  | 5 | **`operation_id`** | `string` | Operation ID - may be empty if the operation completed synchronously. |
  | 6 | **`operation_token`** | `string` | Operation token - may be empty if the operation completed synchronously. |
  | 1 | **`scheduled_event_id`** | `int64` | The NexusOperationScheduled event ID. |
  | 3 | **`service`** | `string` | Service name. |

  ### Additional Notes

    * `operation_id` (`string`): Operation ID - may be empty if the operation completed synchronously.

      Deprecated. Renamed to operation_token.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :endpoint, 2, type: :string
  field :service, 3, type: :string
  field :operation, 4, type: :string
  field :operation_id, 5, type: :string, json_name: "operationId", deprecated: true
  field :operation_token, 6, type: :string, json_name: "operationToken"
end
