defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for DescribeWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 1 | **`namespace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
end
