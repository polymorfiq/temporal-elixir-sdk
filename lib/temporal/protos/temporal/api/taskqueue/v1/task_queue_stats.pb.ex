defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:approximate_backlog_count, 1, type: :int64, json_name: "approximateBacklogCount")

  field(:approximate_backlog_age, 2,
    type: Google.Protobuf.Duration,
    json_name: "approximateBacklogAge"
  )

  field(:tasks_add_rate, 3, type: :float, json_name: "tasksAddRate")
  field(:tasks_dispatch_rate, 4, type: :float, json_name: "tasksDispatchRate")
end
