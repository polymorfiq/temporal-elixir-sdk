defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes do
  @moduledoc """
  Automatically generated module for StickyExecutionAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | (-- api-linter: core::0140::prepositions=disabled |
  | 1 | **`worker_task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |

  ### Additional Notes

    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "workerTaskQueue"

  field :schedule_to_start_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
end
