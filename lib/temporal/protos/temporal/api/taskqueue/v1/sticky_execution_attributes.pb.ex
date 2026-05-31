defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:worker_task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "workerTaskQueue"
  )

  field(:schedule_to_start_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )
end
