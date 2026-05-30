defmodule Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionStartedEventAttributes do
  @moduledoc """
  Automatically generated module for ChildWorkflowExecutionStartedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 2 | **`initiated_event_id`** | `int64` | Id of the `START_CHILD_WORKFLOW_EXECUTION_INITIATED` event which this event corresponds to |
  | 1 | **`namespace`** | `string` | Namespace of the child workflow. |
  | 6 | **`namespace_id`** | `string` |  |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 4 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `namespace` (`string`): Namespace of the child workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :namespace_id, 6, type: :string, json_name: "namespaceId"
  field :initiated_event_id, 2, type: :int64, json_name: "initiatedEventId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :workflow_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :header, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Header
end
