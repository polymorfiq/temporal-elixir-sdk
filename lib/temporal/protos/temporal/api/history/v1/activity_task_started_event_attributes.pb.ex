defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:identity, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
  field(:attempt, 4, type: :int32)

  field(:last_failure, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"
  )

  field(:worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:build_id_redirect_counter, 7,
    type: :int64,
    json_name: "buildIdRedirectCounter",
    deprecated: true
  )
end
