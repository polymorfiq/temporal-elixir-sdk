defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowRuleRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:rule_id, 2, type: :string, json_name: "ruleId")
end
