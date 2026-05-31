defmodule Temporal.Protos.Temporal.Api.Workflow.V1.RequestIdInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:event_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EventType,
    json_name: "eventType",
    enum: true
  )

  field(:event_id, 2, type: :int64, json_name: "eventId")
  field(:buffered, 3, type: :bool)
end
