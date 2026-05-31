defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:backlog_count_hint, 1, type: :int64, json_name: "backlogCountHint")
  field(:read_level, 2, type: :int64, json_name: "readLevel")
  field(:ack_level, 3, type: :int64, json_name: "ackLevel")
  field(:rate_per_second, 4, type: :double, json_name: "ratePerSecond")

  field(:task_id_block, 5,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskIdBlock,
    json_name: "taskIdBlock"
  )
end
