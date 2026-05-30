defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskScheduledEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowTaskScheduledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`attempt`** | `int32` | Starting at 1, how many attempts there have been to complete this task |
  | 2 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | How long the worker has to process this task once receiving it before it times out |
  | 1 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` | The task queue this workflow task was enqueued in, which could be a normal or sticky queue |

  ### Additional Notes

    * `start_to_close_timeout` (`Google.Protobuf.Duration`): How long the worker has to process this task once receiving it before it times out

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :start_to_close_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :attempt, 3, type: :int32
end
