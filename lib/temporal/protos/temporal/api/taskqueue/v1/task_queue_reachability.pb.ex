defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueReachability do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_queue, 1, type: :string, json_name: "taskQueue")

  field(:reachability, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability,
    enum: true
  )
end
