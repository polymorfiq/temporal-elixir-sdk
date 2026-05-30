defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTriggerWorkflowRule do
  @moduledoc """
  BatchOperationTriggerWorkflowRule sends TriggerWorkflowRule requests to batch workflows.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`id`** | `string` | ID of existing rule. |
  | 1 | **`identity`** | `string` | The identity of the worker/client. |
  | 3 | **`spec`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec` | Rule specification to be applied to the workflow without creating a new rule. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :rule, 0

  field :identity, 1, type: :string
  field :id, 2, type: :string, oneof: 0
  field :spec, 3, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec, oneof: 0
end
