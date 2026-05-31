defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.RequestIdReference do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:request_id, 1, type: :string, json_name: "requestId")

  field(:event_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EventType,
    json_name: "eventType",
    enum: true
  )
end
