defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.EventReference do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:event_id, 1, type: :int64, json_name: "eventId")

  field(:event_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EventType,
    json_name: "eventType",
    enum: true
  )
end
