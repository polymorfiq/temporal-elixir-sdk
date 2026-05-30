defmodule Temporal.Protos.Temporal.Api.History.V1.RequestCancelExternalWorkflowExecutionInitiatedEventAttributes do
  @moduledoc """
  Automatically generated module for RequestCancelExternalWorkflowExecutionInitiatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`child_workflow_only`** | `bool` | Workers are expected to set this to true if the workflow they are requesting to cancel is |
  | 4 | **`control`** | `string` | Deprecated. |
  | 2 | **`namespace`** | `string` | The namespace the workflow to be cancelled lives in. |
  | 7 | **`namespace_id`** | `string` |  |
  | 6 | **`reason`** | `string` | Reason for requesting the cancellation |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 1 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `child_workflow_only` (`bool`): Workers are expected to set this to true if the workflow they are requesting to cancel is
      a child of the workflow which issued the request
    * `namespace` (`string`): The namespace the workflow to be cancelled lives in.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :namespace, 2, type: :string
  field :namespace_id, 7, type: :string, json_name: "namespaceId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :control, 4, type: :string, deprecated: true
  field :child_workflow_only, 5, type: :bool, json_name: "childWorkflowOnly"
  field :reason, 6, type: :string
end
