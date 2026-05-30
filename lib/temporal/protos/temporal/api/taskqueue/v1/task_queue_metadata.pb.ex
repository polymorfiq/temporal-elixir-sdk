defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueMetadata do
  @moduledoc """
  Only applies to activity task queues

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`max_tasks_per_second`** | `Google.Protobuf.DoubleValue` | Allows throttling dispatch of tasks from this queue |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :max_tasks_per_second, 1,
    type: Google.Protobuf.DoubleValue,
    json_name: "maxTasksPerSecond"
end
