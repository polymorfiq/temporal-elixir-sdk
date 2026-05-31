defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAcceptedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:protocol_instance_id, 1, type: :string, json_name: "protocolInstanceId")
  field(:accepted_request_message_id, 2, type: :string, json_name: "acceptedRequestMessageId")

  field(:accepted_request_sequencing_event_id, 3,
    type: :int64,
    json_name: "acceptedRequestSequencingEventId"
  )

  field(:accepted_request, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "acceptedRequest"
  )
end
