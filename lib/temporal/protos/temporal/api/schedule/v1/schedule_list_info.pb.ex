defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleListInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:spec, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec)

  field(:workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:notes, 3, type: :string)
  field(:paused, 4, type: :bool)

  field(:recent_actions, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult,
    json_name: "recentActions"
  )

  field(:future_action_times, 6,
    repeated: true,
    type: Google.Protobuf.Timestamp,
    json_name: "futureActionTimes"
  )

  field(:state_size_bytes, 7, type: :int64, json_name: "stateSizeBytes")
end
