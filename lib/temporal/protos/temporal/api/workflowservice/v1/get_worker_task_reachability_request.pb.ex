defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:build_ids, 2, repeated: true, type: :string, json_name: "buildIds")
  field(:task_queues, 3, repeated: true, type: :string, json_name: "taskQueues")

  field(:reachability, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability,
    enum: true
  )
end
