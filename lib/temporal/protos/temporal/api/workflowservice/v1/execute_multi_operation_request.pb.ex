defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest do
  @moduledoc """
  Automatically generated module for ExecuteMultiOperationRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`operations`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation` | List of operations to execute within a single workflow. |
  | 3 | **`resource_id`** | `string` | Resource ID for routing. Should match operations[0].start_workflow.workflow_id |

  ### Additional Notes

    * `operations` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation`): List of operations to execute within a single workflow.

      Preconditions:
      - The list of operations must not be empty.
      - The workflow ids must match across operations.
      - The only valid list of operations at this time is [StartWorkflow, UpdateWorkflow], in this order.

      Note that additional operation-specific restrictions have to be considered.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :operations, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation

  field :resource_id, 3, type: :string, json_name: "resourceId"
end
