defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionListInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:activity_id, 1, type: :string, json_name: "activityId")
  field(:run_id, 2, type: :string, json_name: "runId")

  field(:activity_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:schedule_time, 4, type: Google.Protobuf.Timestamp, json_name: "scheduleTime")
  field(:close_time, 5, type: Google.Protobuf.Timestamp, json_name: "closeTime")

  field(:status, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus,
    enum: true
  )

  field(:search_attributes, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:task_queue, 8, type: :string, json_name: "taskQueue")
  field(:state_transition_count, 9, type: :int64, json_name: "stateTransitionCount")
  field(:state_size_bytes, 10, type: :int64, json_name: "stateSizeBytes")
  field(:execution_duration, 11, type: Google.Protobuf.Duration, json_name: "executionDuration")
end
