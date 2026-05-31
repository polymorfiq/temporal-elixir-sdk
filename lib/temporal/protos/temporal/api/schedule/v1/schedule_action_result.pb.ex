defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:schedule_time, 1, type: Google.Protobuf.Timestamp, json_name: "scheduleTime")
  field(:actual_time, 2, type: Google.Protobuf.Timestamp, json_name: "actualTime")

  field(:start_workflow_result, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "startWorkflowResult"
  )

  field(:start_workflow_status, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    json_name: "startWorkflowStatus",
    enum: true
  )
end
