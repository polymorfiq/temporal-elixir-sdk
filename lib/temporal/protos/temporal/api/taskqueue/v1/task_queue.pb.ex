defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue do
  @moduledoc """
  See https://docs.temporal.io/docs/concepts/task-queues/

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`kind`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueKind` | Default: TASK_QUEUE_KIND_NORMAL. |
  | 1 | **`name`** | `string` |  |
  | 3 | **`normal_name`** | `string` | Iff kind == TASK_QUEUE_KIND_STICKY, then this field contains the name of |

  ### Additional Notes

    * `normal_name` (`string`): Iff kind == TASK_QUEUE_KIND_STICKY, then this field contains the name of
      the normal task queue that the sticky worker is running on.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :kind, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueKind, enum: true
  field :normal_name, 3, type: :string, json_name: "normalName"
end
