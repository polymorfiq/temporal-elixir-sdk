defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionListInfo do
  @moduledoc """
  Limited activity information returned in the list response.
  When adding fields here, ensure that it is also present in ActivityExecutionInfo (note that it
  may already be present in ActivityExecutionInfo but not at the top-level).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_id`** | `string` | A unique identifier of this activity within its namespace along with run ID (below). |
  | 3 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` | The type of the activity, a string that maps to a registered activity on a worker. |
  | 5 | **`close_time`** | `Google.Protobuf.Timestamp` | If the activity is in a terminal status, this field represents the time the activity transitioned to that status. |
  | 11 | **`execution_duration`** | `Google.Protobuf.Duration` | The difference between close time and scheduled time. |
  | 2 | **`run_id`** | `string` | The run ID of the standalone activity. |
  | 4 | **`schedule_time`** | `Google.Protobuf.Timestamp` | Time the activity was originally scheduled via a StartActivityExecution request. |
  | 7 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` | Search attributes from the start request. |
  | 10 | **`state_size_bytes`** | `int64` | Updated once on scheduled and once on terminal status. |
  | 9 | **`state_transition_count`** | `int64` | Updated on terminal status. |
  | 6 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus` | Only scheduled and terminal statuses appear here. More detailed information in PendingActivityInfo but not |
  | 8 | **`task_queue`** | `string` | The task queue this activity was scheduled on when it was originally started, updated on activity options update. |

  ### Additional Notes

    * `execution_duration` (`Google.Protobuf.Duration`): The difference between close time and scheduled time.
      This field is only populated if the activity is closed.
    * `status` (`Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus`): Only scheduled and terminal statuses appear here. More detailed information in PendingActivityInfo but not
      available in the list response.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :activity_id, 1, type: :string, json_name: "activityId"
  field :run_id, 2, type: :string, json_name: "runId"

  field :activity_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :schedule_time, 4, type: Google.Protobuf.Timestamp, json_name: "scheduleTime"
  field :close_time, 5, type: Google.Protobuf.Timestamp, json_name: "closeTime"

  field :status, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityExecutionStatus,
    enum: true

  field :search_attributes, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :task_queue, 8, type: :string, json_name: "taskQueue"
  field :state_transition_count, 9, type: :int64, json_name: "stateTransitionCount"
  field :state_size_bytes, 10, type: :int64, json_name: "stateSizeBytes"
  field :execution_duration, 11, type: Google.Protobuf.Duration, json_name: "executionDuration"
end
