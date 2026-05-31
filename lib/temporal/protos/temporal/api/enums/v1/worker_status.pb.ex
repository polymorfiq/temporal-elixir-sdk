defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKER_STATUS_UNSPECIFIED, 0)
  field(:WORKER_STATUS_RUNNING, 1)
  field(:WORKER_STATUS_SHUTTING_DOWN, 2)
  field(:WORKER_STATUS_SHUTDOWN, 3)
end
