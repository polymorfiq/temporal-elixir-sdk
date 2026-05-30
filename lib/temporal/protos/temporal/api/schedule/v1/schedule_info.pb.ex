defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleInfo do
  @moduledoc """
  Automatically generated module for ScheduleInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`action_count`** | `int64` | Number of actions taken so far. |
  | 10 | **`buffer_dropped`** | `int64` | Number of dropped actions due to buffer limit. |
  | 11 | **`buffer_size`** | `int64` | Number of actions in the buffer. The buffer holds the actions that cannot |
  | 6 | **`create_time`** | `Google.Protobuf.Timestamp` | Timestamps of schedule creation and last update. |
  | 5 | **`future_action_times`** | `Google.Protobuf.Timestamp` | Next ten scheduled action times. |
  | 8 | **`invalid_schedule_error`** | `string` | Deprecated. |
  | 2 | **`missed_catchup_window`** | `int64` | Number of times a scheduled action was skipped due to missing the catchup window. |
  | 3 | **`overlap_skipped`** | `int64` | Number of skipped actions due to overlap. |
  | 4 | **`recent_actions`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult` | Most recent ten actual action times (including manual triggers). |
  | 9 | **`running_workflows`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Currently-running workflows started by this schedule. (There might be |
  | 12 | **`state_size_bytes`** | `int64` | Size of the schedule's internal state (including payloads) in bytes. |
  | 7 | **`update_time`** | `Google.Protobuf.Timestamp` |  |

  ### Additional Notes

    * `buffer_size` (`int64`): Number of actions in the buffer. The buffer holds the actions that cannot
      be immediately triggered (due to the overlap policy). These actions can be a result of
      the normal schedule or a backfill.
    * `running_workflows` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): Currently-running workflows started by this schedule. (There might be
      more than one if the overlap policy allows overlaps.)
      Note that the run_ids in here are the original execution run ids as
      started by the schedule. If the workflows retried, did continue-as-new,
      or were reset, they might still be running but with a different run_id.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :action_count, 1, type: :int64, json_name: "actionCount"
  field :missed_catchup_window, 2, type: :int64, json_name: "missedCatchupWindow"
  field :overlap_skipped, 3, type: :int64, json_name: "overlapSkipped"
  field :buffer_dropped, 10, type: :int64, json_name: "bufferDropped"
  field :buffer_size, 11, type: :int64, json_name: "bufferSize"

  field :running_workflows, 9,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "runningWorkflows"

  field :recent_actions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleActionResult,
    json_name: "recentActions"

  field :future_action_times, 5,
    repeated: true,
    type: Google.Protobuf.Timestamp,
    json_name: "futureActionTimes"

  field :create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime"

  field :invalid_schedule_error, 8,
    type: :string,
    json_name: "invalidScheduleError",
    deprecated: true

  field :state_size_bytes, 12, type: :int64, json_name: "stateSizeBytes"
end
