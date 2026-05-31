defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordWorkerHeartbeatRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)

  field(:worker_heartbeat, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"
  )

  field(:resource_id, 4, type: :string, json_name: "resourceId")
end
