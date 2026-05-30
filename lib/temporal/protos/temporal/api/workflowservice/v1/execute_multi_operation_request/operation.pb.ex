defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation do
  @moduledoc """
  Automatically generated module for Operation

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`start_workflow`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionRequest` |  |
  | 2 | **`update_workflow`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest` | List of operations to execute within a single workflow. |

  ### Additional Notes

    * `update_workflow` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest`): List of operations to execute within a single workflow.

      Preconditions:
      - The list of operations must not be empty.
      - The workflow ids must match across operations.
      - The only valid list of operations at this time is [StartWorkflow, UpdateWorkflow], in this order.

      Note that additional operation-specific restrictions have to be considered.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :operation, 0

  field :start_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionRequest,
    json_name: "startWorkflow",
    oneof: 0

  field :update_workflow, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest,
    json_name: "updateWorkflow",
    oneof: 0
end
