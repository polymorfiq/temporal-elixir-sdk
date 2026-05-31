defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskTimedOutEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")

  field(:timeout_type, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TimeoutType,
    json_name: "timeoutType",
    enum: true
  )
end
