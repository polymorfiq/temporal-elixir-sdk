defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus do
  @moduledoc """
  Deprecated. Use `InternalTaskQueueStatus`. This is kept until `DescribeTaskQueue` supports legacy behavior.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`ack_level`** | `int64` |  |
  | 1 | **`backlog_count_hint`** | `int64` |  |
  | 4 | **`rate_per_second`** | `double` |  |
  | 2 | **`read_level`** | `int64` |  |
  | 5 | **`task_id_block`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskIdBlock` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :backlog_count_hint, 1, type: :int64, json_name: "backlogCountHint"
  field :read_level, 2, type: :int64, json_name: "readLevel"
  field :ack_level, 3, type: :int64, json_name: "ackLevel"
  field :rate_per_second, 4, type: :double, json_name: "ratePerSecond"

  field :task_id_block, 5,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskIdBlock,
    json_name: "taskIdBlock"
end
