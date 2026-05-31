defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:types_info, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo.TypesInfoEntry,
    json_name: "typesInfo",
    map: true
  )

  field(:task_reachability, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.BuildIdTaskReachability,
    json_name: "taskReachability",
    enum: true
  )
end
