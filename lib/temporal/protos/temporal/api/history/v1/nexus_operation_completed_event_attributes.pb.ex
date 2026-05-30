defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationCompletedEventAttributes do
  @moduledoc """
  Nexus operation completed successfully.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`request_id`** | `string` | The request ID allocated at schedule time. |
  | 2 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Serialized result of the Nexus operation. The response of the Nexus handler. |
  | 1 | **`scheduled_event_id`** | `int64` | The ID of the `NEXUS_OPERATION_SCHEDULED` event. Uniquely identifies this operation. |

  ### Additional Notes

    * `result` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Serialized result of the Nexus operation. The response of the Nexus handler.
      Delivered either via a completion callback or as a response to a synchronous operation.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :result, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
  field :request_id, 3, type: :string, json_name: "requestId"
end
