defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedResponse do
  @moduledoc """
  Automatically generated module for RespondWorkflowTaskCompletedResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`activity_tasks`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueResponse` | See `ScheduleActivityTaskCommandAttributes::request_eager_execution` |
  | 3 | **`reset_history_event_id`** | `int64` | If non zero, indicates the server has discarded the workflow task that was being responded to. |
  | 1 | **`workflow_task`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse` | See `RespondWorkflowTaskCompletedResponse::return_new_workflow_task` |

  ### Additional Notes

    * `reset_history_event_id` (`int64`): If non zero, indicates the server has discarded the workflow task that was being responded to.
      Will be the event ID of the last workflow task started event in the history before the new workflow task.
      Server is only expected to discard a workflow task if it could not have modified the workflow state.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task, 1,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse,
    json_name: "workflowTask"

  field :activity_tasks, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueResponse,
    json_name: "activityTasks"

  field :reset_history_event_id, 3, type: :int64, json_name: "resetHistoryEventId"
end
