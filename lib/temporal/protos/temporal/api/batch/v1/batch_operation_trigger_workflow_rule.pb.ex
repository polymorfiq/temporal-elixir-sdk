defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTriggerWorkflowRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:rule, 0)

  field(:identity, 1, type: :string)
  field(:id, 2, type: :string, oneof: 0)
  field(:spec, 3, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec, oneof: 0)
end
