defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationStartedEventAttributes do
  @moduledoc """
  Event marking an asynchronous operation was started by the responding Nexus handler.
  If the operation completes synchronously, this event is not generated.
  In rare situations, such as request timeouts, the service may fail to record the actual start time and will fabricate
  this event upon receiving the operation completion via callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`operation_id`** | `string` | The operation ID returned by the Nexus handler in the response to the StartOperation request. |
  | 5 | **`operation_token`** | `string` | The operation token returned by the Nexus handler in the response to the StartOperation request. |
  | 4 | **`request_id`** | `string` | The request ID allocated at schedule time. |
  | 1 | **`scheduled_event_id`** | `int64` | The ID of the `NEXUS_OPERATION_SCHEDULED` event this task corresponds to. |

  ### Additional Notes

    * `operation_id` (`string`): The operation ID returned by the Nexus handler in the response to the StartOperation request.
      This ID is used when canceling the operation.

      Deprecated: Renamed to operation_token.
    * `operation_token` (`string`): The operation token returned by the Nexus handler in the response to the StartOperation request.
      This token is used when canceling the operation.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :operation_id, 3, type: :string, json_name: "operationId", deprecated: true
  field :request_id, 4, type: :string, json_name: "requestId"
  field :operation_token, 5, type: :string, json_name: "operationToken"
end
