defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateRejectedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionUpdateRejectedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The cause of rejection. |
  | 1 | **`protocol_instance_id`** | `string` | The instance ID of the update protocol that generated this event. |
  | 4 | **`rejected_request`** | `Temporal.Protos.Temporal.Api.Update.V1.Request` | The message payload of the original request message that initiated this |
  | 2 | **`rejected_request_message_id`** | `string` | The message ID of the original request message that initiated this |
  | 3 | **`rejected_request_sequencing_event_id`** | `int64` | The event ID used to sequence the original request message. |

  ### Additional Notes

    * `rejected_request` (`Temporal.Protos.Temporal.Api.Update.V1.Request`): The message payload of the original request message that initiated this
      update.
    * `rejected_request_message_id` (`string`): The message ID of the original request message that initiated this
      update. Needed so that the worker can recreate and deliver that same
      message as part of replay.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :protocol_instance_id, 1, type: :string, json_name: "protocolInstanceId"
  field :rejected_request_message_id, 2, type: :string, json_name: "rejectedRequestMessageId"

  field :rejected_request_sequencing_event_id, 3,
    type: :int64,
    json_name: "rejectedRequestSequencingEventId"

  field :rejected_request, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "rejectedRequest"

  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
