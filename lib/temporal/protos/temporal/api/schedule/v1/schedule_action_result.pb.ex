defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult do
  @moduledoc """
  Automatically generated module for ScheduleActionResult

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`actual_time`** | `Google.Protobuf.Timestamp` | Time that the action was taken (real time). |
  | 1 | **`schedule_time`** | `Google.Protobuf.Timestamp` | Time that the action was taken (according to the schedule, including jitter). |
  | 11 | **`start_workflow_result`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | If action was start_workflow: |
  | 12 | **`start_workflow_status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus` | If the action was start_workflow, this field will reflect an |

  ### Additional Notes

    * `start_workflow_status` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus`): If the action was start_workflow, this field will reflect an
      eventually-consistent view of the started workflow's status.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :schedule_time, 1, type: Google.Protobuf.Timestamp, json_name: "scheduleTime"
  field :actual_time, 2, type: Google.Protobuf.Timestamp, json_name: "actualTime"

  field :start_workflow_result, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "startWorkflowResult"

  field :start_workflow_status, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    json_name: "startWorkflowStatus",
    enum: true
end
