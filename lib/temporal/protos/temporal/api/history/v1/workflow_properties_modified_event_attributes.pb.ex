defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowPropertiesModifiedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowPropertiesModifiedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`upserted_memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | If set, update the workflow memo with the provided values. The values will be merged with |
  | 1 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `upserted_memo` (`Temporal.Protos.Temporal.Api.Common.V1.Memo`): If set, update the workflow memo with the provided values. The values will be merged with
      the existing memo. If the user wants to delete values, a default/empty Payload should be
      used as the value for the key being deleted.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :upserted_memo, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Memo,
    json_name: "upsertedMemo"
end
