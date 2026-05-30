defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleListInfo do
  @moduledoc """
  ScheduleListInfo is an abbreviated set of values from Schedule and ScheduleInfo
  that's returned in ListSchedules.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`future_action_times`** | `Google.Protobuf.Timestamp` |  |
  | 3 | **`notes`** | `string` | From state: |
  | 4 | **`paused`** | `bool` |  |
  | 5 | **`recent_actions`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult` | From info (maybe fewer entries): |
  | 1 | **`spec`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec` | From spec: |
  | 7 | **`state_size_bytes`** | `int64` | Size of the schedule's internal state (including payloads) in bytes. |
  | 2 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` | From action: |

  ### Additional Notes

    * `spec` (`Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec`): From spec:
      Some fields are dropped from this copy of spec: timezone_data
    * `workflow_type` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowType`): From action:
      Action is a oneof field, but we need to encode this in JSON and oneof fields don't work
      well with JSON. If action is start_workflow, this is set:

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :spec, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec

  field :workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :notes, 3, type: :string
  field :paused, 4, type: :bool

  field :recent_actions, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult,
    json_name: "recentActions"

  field :future_action_times, 6,
    repeated: true,
    type: Google.Protobuf.Timestamp,
    json_name: "futureActionTimes"

  field :state_size_bytes, 7, type: :int64, json_name: "stateSizeBytes"
end
