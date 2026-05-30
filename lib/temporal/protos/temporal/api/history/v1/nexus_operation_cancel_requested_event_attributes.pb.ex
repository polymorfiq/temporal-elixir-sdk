defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationCancelRequestedEventAttributes do
  @moduledoc """
  Automatically generated module for NexusOperationCancelRequestedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `NEXUS_OPERATION_SCHEDULED` event this cancel request corresponds to. |
  | 2 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event that the corresponding RequestCancelNexusOperation command was reported |

  ### Additional Notes

    * `workflow_task_completed_event_id` (`int64`): The `WORKFLOW_TASK_COMPLETED` event that the corresponding RequestCancelNexusOperation command was reported
      with.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"

  field :workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
end
