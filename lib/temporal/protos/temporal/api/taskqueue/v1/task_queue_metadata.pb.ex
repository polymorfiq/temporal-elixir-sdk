defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:max_tasks_per_second, 1,
    type: Google.Protobuf.DoubleValue,
    json_name: "maxTasksPerSecond"
  )
end
