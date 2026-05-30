defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationReset do
  @moduledoc """
  BatchOperationReset sends reset requests to batch workflows.
  Keep the parameter in sync with temporal.api.workflowservice.v1.ResetWorkflowExecutionRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`identity`** | `string` | The identity of the worker/client. |
  | 4 | **`options`** | `Temporal.Protos.Temporal.Api.Common.V1.ResetOptions` | Describes what to reset to and how. If set, `reset_type` and `reset_reapply_type` are ignored. |
  | 5 | **`post_reset_operations`** | `Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation` | Operations to perform after the workflow has been reset. These operations will be applied |
  | 2 | **`reset_reapply_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType` | Deprecated. Use `options`. |
  | 1 | **`reset_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetType` | Deprecated. Use `options`. |

  ### Additional Notes

    * `post_reset_operations` (`Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation`): Operations to perform after the workflow has been reset. These operations will be applied
      to the *new* run of the workflow execution in the order they are provided.
      All operations are applied to the workflow before the first new workflow task is generated

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 3, type: :string
  field :options, 4, type: Temporal.Protos.Temporal.Api.Common.V1.ResetOptions

  field :reset_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetType,
    json_name: "resetType",
    enum: true,
    deprecated: true

  field :reset_reapply_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true

  field :post_reset_operations, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation,
    json_name: "postResetOperations"
end
