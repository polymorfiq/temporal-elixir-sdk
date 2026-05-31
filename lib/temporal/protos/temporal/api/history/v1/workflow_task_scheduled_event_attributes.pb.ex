defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskScheduledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:start_to_close_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:attempt, 3, type: :int32)
end
