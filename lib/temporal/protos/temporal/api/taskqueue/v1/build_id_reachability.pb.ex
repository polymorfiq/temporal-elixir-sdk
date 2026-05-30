defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability do
  @moduledoc """
  Reachability of tasks for a worker by build id, in one or more task queues.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_id`** | `string` | A build id or empty if unversioned. |
  | 2 | **`task_queue_reachability`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueReachability` | Reachability per task queue. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id, 1, type: :string, json_name: "buildId"

  field :task_queue_reachability, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueReachability,
    json_name: "taskQueueReachability"
end
