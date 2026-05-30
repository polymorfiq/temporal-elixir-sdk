defmodule Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :TASK_QUEUE_TYPE_UNSPECIFIED, 0
  field :TASK_QUEUE_TYPE_WORKFLOW, 1
  field :TASK_QUEUE_TYPE_ACTIVITY, 2
  field :TASK_QUEUE_TYPE_NEXUS, 3
end
