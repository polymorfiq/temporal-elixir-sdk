defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCompletedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:scheduled_event_id, 2, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 3, type: :int64, json_name: "startedEventId")
  field(:identity, 4, type: :string)

  field(:worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )
end
