defmodule Temporal.Protos.Temporal.Api.Update.V1.Acceptance do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:accepted_request_message_id, 1, type: :string, json_name: "acceptedRequestMessageId")

  field(:accepted_request_sequencing_event_id, 2,
    type: :int64,
    json_name: "acceptedRequestSequencingEventId"
  )

  field(:accepted_request, 3,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "acceptedRequest"
  )
end
