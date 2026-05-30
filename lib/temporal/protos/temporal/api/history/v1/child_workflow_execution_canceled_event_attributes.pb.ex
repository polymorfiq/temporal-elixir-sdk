defmodule Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionCanceledEventAttributes do
  @moduledoc """
  Automatically generated module for ChildWorkflowExecutionCanceledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 5 | **`initiated_event_id`** | `int64` | Id of the `START_CHILD_WORKFLOW_EXECUTION_INITIATED` event which this event corresponds to |
  | 2 | **`namespace`** | `string` | Namespace of the child workflow. |
  | 7 | **`namespace_id`** | `string` |  |
  | 6 | **`started_event_id`** | `int64` | Id of the `CHILD_WORKFLOW_EXECUTION_STARTED` event which this event corresponds to |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 4 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `namespace` (`string`): Namespace of the child workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :namespace, 2, type: :string
  field :namespace_id, 7, type: :string, json_name: "namespaceId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :workflow_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :initiated_event_id, 5, type: :int64, json_name: "initiatedEventId"
  field :started_event_id, 6, type: :int64, json_name: "startedEventId"
end
