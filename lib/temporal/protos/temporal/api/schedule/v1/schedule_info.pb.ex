defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:action_count, 1, type: :int64, json_name: "actionCount")
  field(:missed_catchup_window, 2, type: :int64, json_name: "missedCatchupWindow")
  field(:overlap_skipped, 3, type: :int64, json_name: "overlapSkipped")
  field(:buffer_dropped, 10, type: :int64, json_name: "bufferDropped")
  field(:buffer_size, 11, type: :int64, json_name: "bufferSize")

  field(:running_workflows, 9,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "runningWorkflows"
  )

  field(:recent_actions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult,
    json_name: "recentActions"
  )

  field(:future_action_times, 5,
    repeated: true,
    type: Google.Protobuf.Timestamp,
    json_name: "futureActionTimes"
  )

  field(:create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime")
  field(:update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime")

  field(:invalid_schedule_error, 8,
    type: :string,
    json_name: "invalidScheduleError",
    deprecated: true
  )

  field(:state_size_bytes, 12, type: :int64, json_name: "stateSizeBytes")
end
