defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.StatsByPriorityKeyEntry do
  @moduledoc """
  Automatically generated module for StatsByPriorityKeyEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `int32` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats` | Statistics for the task queue. |

  ### Additional Notes

    * `value` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats`): Statistics for the task queue.
      Only set if `report_stats` is set on the request.

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :int32
  field :value, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats
end
