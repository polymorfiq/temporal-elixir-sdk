defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionOptionsRequest do
  @moduledoc """
  Keep the parameters in sync with:
  - temporal.api.batch.v1.BatchOperationUpdateWorkflowExecutionOptions.
  - temporal.api.workflow.v1.PostResetOperation.UpdateWorkflowOptions.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | The namespace name of the target Workflow. |
  | 4 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `workflow_execution_options` will be applied. |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | The target Workflow Id and (optionally) a specific Run Id thereof. |
  | 3 | **`workflow_execution_options`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions` | Workflow Execution options. Partial updates are accepted and controlled by update_mask. |

  ### Additional Notes

    * `update_mask` (`Google.Protobuf.FieldMask`): Controls which fields from `workflow_execution_options` will be applied.
      To unset a field, set it to null and use the update mask to indicate that it should be mutated.
    * `workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): The target Workflow Id and (optionally) a specific Run Id thereof.
      (-- api-linter: core::0203::optional=disabled
          aip.dev/not-precedent: false positive triggered by the word "optional" --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :workflow_execution_options, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"

  field :update_mask, 4, type: Google.Protobuf.FieldMask, json_name: "updateMask"
  field :identity, 5, type: :string
end
