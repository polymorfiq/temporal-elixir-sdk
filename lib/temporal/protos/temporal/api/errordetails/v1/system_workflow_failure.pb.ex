defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.SystemWorkflowFailure do
  @moduledoc """
  Automatically generated module for SystemWorkflowFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`workflow_error`** | `string` | Serialized error returned by the system workflow performing the underlying operation. |
  | 1 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | WorkflowId and RunId of the Temporal system workflow performing the underlying operation. |

  ### Additional Notes

    * `workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): WorkflowId and RunId of the Temporal system workflow performing the underlying operation.
      Looking up the info of the system workflow run may help identify the issue causing the failure.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_execution, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :workflow_error, 2, type: :string, json_name: "workflowError"
end
