defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateRejectedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:protocol_instance_id, 1, type: :string, json_name: "protocolInstanceId")
  field(:rejected_request_message_id, 2, type: :string, json_name: "rejectedRequestMessageId")

  field(:rejected_request_sequencing_event_id, 3,
    type: :int64,
    json_name: "rejectedRequestSequencingEventId"
  )

  field(:rejected_request, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "rejectedRequest"
  )

  field(:failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
