defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCanceledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:latest_cancel_requested_event_id, 2,
    type: :int64,
    json_name: "latestCancelRequestedEventId"
  )

  field(:scheduled_event_id, 3, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 4, type: :int64, json_name: "startedEventId")
  field(:identity, 5, type: :string)

  field(:worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )
end
