defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:selector, 0)

  field(:worker_instance_key, 1, type: :string, json_name: "workerInstanceKey", oneof: 0)
end
