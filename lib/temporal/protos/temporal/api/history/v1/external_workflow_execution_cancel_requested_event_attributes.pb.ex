defmodule Temporal.Protos.Temporal.Api.History.V1.ExternalWorkflowExecutionCancelRequestedEventAttributes do
  @moduledoc """
  Automatically generated module for ExternalWorkflowExecutionCancelRequestedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`initiated_event_id`** | `int64` | id of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event this event corresponds |
  | 2 | **`namespace`** | `string` | Namespace of the to-be-cancelled workflow. |
  | 4 | **`namespace_id`** | `string` |  |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  ### Additional Notes

    * `initiated_event_id` (`int64`): id of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event this event corresponds
      to
    * `namespace` (`string`): Namespace of the to-be-cancelled workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :initiated_event_id, 1, type: :int64, json_name: "initiatedEventId"
  field :namespace, 2, type: :string
  field :namespace_id, 4, type: :string, json_name: "namespaceId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
end
