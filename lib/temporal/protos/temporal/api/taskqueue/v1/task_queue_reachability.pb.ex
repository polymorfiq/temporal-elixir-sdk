defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueReachability do
  @moduledoc """
  Reachability of tasks for a worker on a single task queue.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`reachability`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability` | Task reachability for a worker in a single task queue. |
  | 1 | **`task_queue`** | `string` |  |

  ### Additional Notes

    * `reachability` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability`): Task reachability for a worker in a single task queue.
      See the TaskReachability docstring for information about each enum variant.
      If reachability is empty, this worker is considered unreachable in this task queue.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue, 1, type: :string, json_name: "taskQueue"

  field :reachability, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability,
    enum: true
end
