defmodule Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.Trigger do
  @moduledoc """
  CallbackInfo contains the state of an attached workflow callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`update_workflow_execution_completed`** | `Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.UpdateWorkflowExecutionCompleted` | Trigger for this callback. |
  | 1 | **`workflow_closed`** | `Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.WorkflowClosed` | Information on how this callback should be invoked (e.g. its URL and type). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :workflow_closed, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.WorkflowClosed,
    json_name: "workflowClosed",
    oneof: 0

  field :update_workflow_execution_completed, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.UpdateWorkflowExecutionCompleted,
    json_name: "updateWorkflowExecutionCompleted",
    oneof: 0
end
