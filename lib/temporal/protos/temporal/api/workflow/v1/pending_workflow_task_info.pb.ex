defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingWorkflowTaskInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:state, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingWorkflowTaskState,
    enum: true
  )

  field(:scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")

  field(:original_scheduled_time, 3,
    type: Google.Protobuf.Timestamp,
    json_name: "originalScheduledTime"
  )

  field(:started_time, 4, type: Google.Protobuf.Timestamp, json_name: "startedTime")
  field(:attempt, 5, type: :int32)
end
