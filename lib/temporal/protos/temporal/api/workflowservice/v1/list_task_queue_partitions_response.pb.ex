defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListTaskQueuePartitionsResponse do
  @moduledoc """
  Automatically generated module for ListTaskQueuePartitionsResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_task_queue_partitions`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueuePartitionMetadata` |  |
  | 2 | **`workflow_task_queue_partitions`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueuePartitionMetadata` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :activity_task_queue_partitions, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueuePartitionMetadata,
    json_name: "activityTaskQueuePartitions"

  field :workflow_task_queue_partitions, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueuePartitionMetadata,
    json_name: "workflowTaskQueuePartitions"
end
