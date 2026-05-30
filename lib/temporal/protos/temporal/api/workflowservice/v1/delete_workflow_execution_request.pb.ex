defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for DeleteWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Workflow Execution to delete. If run_id is not specified, the latest one is used. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
end
