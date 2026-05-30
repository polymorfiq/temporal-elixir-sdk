defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateWorkflowExecutionOptions do
  @moduledoc """
  BatchOperationUpdateWorkflowExecutionOptions sends UpdateWorkflowExecutionOptions requests to batch workflows.
  Keep the parameters in sync with temporal.api.workflowservice.v1.UpdateWorkflowExecutionOptionsRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker/client. |
  | 3 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `workflow_execution_options` will be applied. |
  | 2 | **`workflow_execution_options`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions` | Update Workflow options that were originally specified via StartWorkflowExecution. Partial updates are accepted and controlled by update_mask. |

  ### Additional Notes

    * `update_mask` (`Google.Protobuf.FieldMask`): Controls which fields from `workflow_execution_options` will be applied.
      To unset a field, set it to null and use the update mask to indicate that it should be mutated.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string

  field :workflow_execution_options, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"

  field :update_mask, 3, type: Google.Protobuf.FieldMask, json_name: "updateMask"
end
