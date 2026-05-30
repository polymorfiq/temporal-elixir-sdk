defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowRuleResponse do
  @moduledoc """
  Automatically generated module for DescribeWorkflowRuleResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`rule`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule` | The rule that was read. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule, 1, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule
end
