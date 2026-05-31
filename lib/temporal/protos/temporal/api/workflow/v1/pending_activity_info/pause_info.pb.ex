defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:paused_by, 0)

  field(:pause_time, 1, type: Google.Protobuf.Timestamp, json_name: "pauseTime")

  field(:manual, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo.Manual,
    oneof: 0
  )

  field(:rule, 4,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo.Rule,
    oneof: 0
  )
end
