defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAcceptedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionUpdateAcceptedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`accepted_request`** | `Temporal.Protos.Temporal.Api.Update.V1.Request` | The message payload of the original request message that initiated this |
  | 2 | **`accepted_request_message_id`** | `string` | The message ID of the original request message that initiated this |
  | 3 | **`accepted_request_sequencing_event_id`** | `int64` | The event ID used to sequence the original request message. |
  | 1 | **`protocol_instance_id`** | `string` | The instance ID of the update protocol that generated this event. |

  ### Additional Notes

    * `accepted_request` (`Temporal.Protos.Temporal.Api.Update.V1.Request`): The message payload of the original request message that initiated this
      update.
    * `accepted_request_message_id` (`string`): The message ID of the original request message that initiated this
      update. Needed so that the worker can recreate and deliver that same
      message as part of replay.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :protocol_instance_id, 1, type: :string, json_name: "protocolInstanceId"
  field :accepted_request_message_id, 2, type: :string, json_name: "acceptedRequestMessageId"

  field :accepted_request_sequencing_event_id, 3,
    type: :int64,
    json_name: "acceptedRequestSequencingEventId"

  field :accepted_request, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "acceptedRequest"
end
