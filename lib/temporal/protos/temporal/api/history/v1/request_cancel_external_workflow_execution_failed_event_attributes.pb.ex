defmodule Temporal.Protos.Temporal.Api.History.V1.RequestCancelExternalWorkflowExecutionFailedEventAttributes do
  @moduledoc """
  Automatically generated module for RequestCancelExternalWorkflowExecutionFailedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.CancelExternalWorkflowExecutionFailedCause` |  |
  | 6 | **`control`** | `string` | Deprecated. |
  | 5 | **`initiated_event_id`** | `int64` | id of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event this failure |
  | 3 | **`namespace`** | `string` | Namespace of the workflow which failed to cancel. |
  | 7 | **`namespace_id`** | `string` |  |
  | 4 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 2 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `initiated_event_id` (`int64`): id of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event this failure
      corresponds to
    * `namespace` (`string`): Namespace of the workflow which failed to cancel.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cause, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.CancelExternalWorkflowExecutionFailedCause,
    enum: true

  field :workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :namespace, 3, type: :string
  field :namespace_id, 7, type: :string, json_name: "namespaceId"

  field :workflow_execution, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :initiated_event_id, 5, type: :int64, json_name: "initiatedEventId"
  field :control, 6, type: :string, deprecated: true
end
