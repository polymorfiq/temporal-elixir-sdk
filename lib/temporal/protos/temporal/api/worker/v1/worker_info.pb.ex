defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:worker_heartbeat, 1,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"
  )
end
