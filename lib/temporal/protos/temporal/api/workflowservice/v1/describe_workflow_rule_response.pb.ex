defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowRuleResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rule, 1, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule)
end
