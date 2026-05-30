defmodule Temporal.Protos.Temporal.Api.History.V1.UpsertWorkflowSearchAttributesEventAttributes do
  @moduledoc """
  Automatically generated module for UpsertWorkflowSearchAttributesEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 1 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :search_attributes, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
end
