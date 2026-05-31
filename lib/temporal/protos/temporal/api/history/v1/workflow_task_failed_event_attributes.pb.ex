defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")

  field(:cause, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause,
    enum: true
  )

  field(:failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:identity, 5, type: :string)
  field(:base_run_id, 6, type: :string, json_name: "baseRunId")
  field(:new_run_id, 7, type: :string, json_name: "newRunId")
  field(:fork_event_version, 8, type: :int64, json_name: "forkEventVersion")
  field(:binary_checksum, 9, type: :string, json_name: "binaryChecksum", deprecated: true)

  field(:worker_version, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )
end
