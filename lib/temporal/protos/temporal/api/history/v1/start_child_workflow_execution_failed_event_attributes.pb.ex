defmodule Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionFailedEventAttributes do
  @moduledoc """
  Automatically generated module for StartChildWorkflowExecutionFailedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.StartChildWorkflowExecutionFailedCause` |  |
  | 5 | **`control`** | `string` | Deprecated. |
  | 6 | **`initiated_event_id`** | `int64` | Id of the `START_CHILD_WORKFLOW_EXECUTION_INITIATED` event which this event corresponds to |
  | 1 | **`namespace`** | `string` | Namespace of the child workflow. |
  | 8 | **`namespace_id`** | `string` |  |
  | 2 | **`workflow_id`** | `string` |  |
  | 7 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `namespace` (`string`): Namespace of the child workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :namespace_id, 8, type: :string, json_name: "namespaceId"
  field :workflow_id, 2, type: :string, json_name: "workflowId"

  field :workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :cause, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.StartChildWorkflowExecutionFailedCause,
    enum: true

  field :control, 5, type: :string, deprecated: true
  field :initiated_event_id, 6, type: :int64, json_name: "initiatedEventId"

  field :workflow_task_completed_event_id, 7,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
end
