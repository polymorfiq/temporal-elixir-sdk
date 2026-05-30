defmodule Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueKind do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :TASK_QUEUE_KIND_UNSPECIFIED, 0
  field :TASK_QUEUE_KIND_NORMAL, 1
  field :TASK_QUEUE_KIND_STICKY, 2
  field :TASK_QUEUE_KIND_WORKER_COMMANDS, 3
end
