defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkflowRuleActionScope do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKFLOW_RULE_ACTION_SCOPE_UNSPECIFIED, 0)
  field(:WORKFLOW_RULE_ACTION_SCOPE_WORKFLOW, 1)
  field(:WORKFLOW_RULE_ACTION_SCOPE_ACTIVITY, 2)
end
