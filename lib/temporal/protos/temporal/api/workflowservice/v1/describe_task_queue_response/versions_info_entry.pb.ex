defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.VersionsInfoEntry do
  @moduledoc """
  Automatically generated module for VersionsInfoEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo` | Statistics for the task queue. |

  ### Additional Notes

    * `value` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo`): Statistics for the task queue.
      Only set if `report_stats` is set on the request.

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo
end
