defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_id, 1, type: :string, json_name: "buildId")

  field(:task_queue_reachability, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueReachability,
    json_name: "taskQueueReachability"
  )
end
