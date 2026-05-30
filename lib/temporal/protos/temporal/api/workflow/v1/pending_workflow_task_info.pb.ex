defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingWorkflowTaskInfo do
  @moduledoc """
  Automatically generated module for PendingWorkflowTaskInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`attempt`** | `int32` |  |
  | 3 | **`original_scheduled_time`** | `Google.Protobuf.Timestamp` | original_scheduled_time is the scheduled time of the first workflow task during workflow task heartbeat. |
  | 2 | **`scheduled_time`** | `Google.Protobuf.Timestamp` |  |
  | 4 | **`started_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.PendingWorkflowTaskState` |  |

  ### Additional Notes

    * `original_scheduled_time` (`Google.Protobuf.Timestamp`): original_scheduled_time is the scheduled time of the first workflow task during workflow task heartbeat.
      Heartbeat workflow task is done by RespondWorkflowTaskComplete with ForceCreateNewWorkflowTask == true and no command
      In this case, OriginalScheduledTime won't change. Then when current time - original_scheduled_time exceeds
      some threshold, the workflow task will be forced timeout.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :state, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingWorkflowTaskState,
    enum: true

  field :scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"

  field :original_scheduled_time, 3,
    type: Google.Protobuf.Timestamp,
    json_name: "originalScheduledTime"

  field :started_time, 4, type: Google.Protobuf.Timestamp, json_name: "startedTime"
  field :attempt, 5, type: :int32
end
