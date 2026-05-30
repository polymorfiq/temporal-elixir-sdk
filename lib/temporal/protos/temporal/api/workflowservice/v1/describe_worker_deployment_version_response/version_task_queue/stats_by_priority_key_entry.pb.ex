defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse.VersionTaskQueue.StatsByPriorityKeyEntry do
  @moduledoc """
  Automatically generated module for StatsByPriorityKeyEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `int32` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats` | All the Task Queues that have ever polled from this Deployment version. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :int32
  field :value, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats
end
