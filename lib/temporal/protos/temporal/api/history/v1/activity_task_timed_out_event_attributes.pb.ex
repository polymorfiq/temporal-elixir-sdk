defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskTimedOutEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:scheduled_event_id, 2, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 3, type: :int64, json_name: "startedEventId")

  field(:retry_state, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )
end
