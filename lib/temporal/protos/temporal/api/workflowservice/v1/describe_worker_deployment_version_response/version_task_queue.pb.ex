defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue do
  @moduledoc """
  Automatically generated module for VersionTaskQueue

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`name`** | `string` |  |
  | 3 | **`stats`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats` |  |
  | 4 | **`stats_by_priority_key`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue.StatsByPriorityKeyEntry` |  |
  | 2 | **`type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | All the Task Queues that have ever polled from this Deployment version. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :type, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType, enum: true
  field :stats, 3, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats

  field :stats_by_priority_key, 4,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue.StatsByPriorityKeyEntry,
    json_name: "statsByPriorityKey",
    map: true
end
