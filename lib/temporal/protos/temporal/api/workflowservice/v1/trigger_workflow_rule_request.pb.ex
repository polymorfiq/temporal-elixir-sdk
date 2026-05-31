defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TriggerWorkflowRuleRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:rule, 0)

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:id, 4, type: :string, oneof: 0)
  field(:spec, 5, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec, oneof: 0)
  field(:identity, 3, type: :string)
end
