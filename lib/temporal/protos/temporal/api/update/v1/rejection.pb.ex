defmodule Temporal.Protos.Temporal.Api.Update.V1.Rejection do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rejected_request_message_id, 1, type: :string, json_name: "rejectedRequestMessageId")

  field(:rejected_request_sequencing_event_id, 2,
    type: :int64,
    json_name: "rejectedRequestSequencingEventId"
  )

  field(:rejected_request, 3,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "rejectedRequest"
  )

  field(:failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
