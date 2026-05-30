defmodule Temporal.Protos.Temporal.Api.History.V1.ExternalWorkflowExecutionSignaledEventAttributes do
  @moduledoc """
  Automatically generated module for ExternalWorkflowExecutionSignaledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`control`** | `string` | Deprecated. |
  | 1 | **`initiated_event_id`** | `int64` | id of the `SIGNAL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event this event corresponds to |
  | 2 | **`namespace`** | `string` | Namespace of the workflow which was signaled. |
  | 5 | **`namespace_id`** | `string` |  |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  ### Additional Notes

    * `namespace` (`string`): Namespace of the workflow which was signaled.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :initiated_event_id, 1, type: :int64, json_name: "initiatedEventId"
  field :namespace, 2, type: :string
  field :namespace_id, 5, type: :string, json_name: "namespaceId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :control, 4, type: :string, deprecated: true
end
