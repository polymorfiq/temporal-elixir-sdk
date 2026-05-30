defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation do
  @moduledoc """
  PostResetOperation represents an operation to be performed on the new workflow execution after a workflow reset.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`signal_workflow`** | `Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.SignalWorkflow` |  |
  | 2 | **`update_workflow_options`** | `Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.UpdateWorkflowOptions` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :signal_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.SignalWorkflow,
    json_name: "signalWorkflow",
    oneof: 0

  field :update_workflow_options, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.UpdateWorkflowOptions,
    json_name: "updateWorkflowOptions",
    oneof: 0
end
