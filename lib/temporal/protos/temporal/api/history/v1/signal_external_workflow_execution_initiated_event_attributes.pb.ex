defmodule Temporal.Protos.Temporal.Api.History.V1.SignalExternalWorkflowExecutionInitiatedEventAttributes do
  @moduledoc """
  Automatically generated module for SignalExternalWorkflowExecutionInitiatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`child_workflow_only`** | `bool` | Workers are expected to set this to true if the workflow they are requesting to cancel is |
  | 6 | **`control`** | `string` | Deprecated. |
  | 8 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 5 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments to provide to the signal handler |
  | 2 | **`namespace`** | `string` | Namespace of the to-be-signalled workflow. |
  | 9 | **`namespace_id`** | `string` |  |
  | 4 | **`signal_name`** | `string` | name/type of the signal to fire in the external workflow |
  | 3 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 1 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `child_workflow_only` (`bool`): Workers are expected to set this to true if the workflow they are requesting to cancel is
      a child of the workflow which issued the request
    * `namespace` (`string`): Namespace of the to-be-signalled workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :namespace, 2, type: :string
  field :namespace_id, 9, type: :string, json_name: "namespaceId"

  field :workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :signal_name, 4, type: :string, json_name: "signalName"
  field :input, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :control, 6, type: :string, deprecated: true
  field :child_workflow_only, 7, type: :bool, json_name: "childWorkflowOnly"
  field :header, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Header
end
