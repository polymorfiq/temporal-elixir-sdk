defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.UpdateWorkflowOptions do
  @moduledoc """
  PostResetOperation represents an operation to be performed on the new workflow execution after a workflow reset.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`update_mask`** | `Google.Protobuf.FieldMask` |  |
  | 1 | **`workflow_execution_options`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_execution_options, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"

  field :update_mask, 2, type: Google.Protobuf.FieldMask, json_name: "updateMask"
end
