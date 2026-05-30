defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TriggerWorkflowRuleRequest do
  @moduledoc """
  Automatically generated module for TriggerWorkflowRuleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Execution info of the workflow which scheduled this activity |
  | 4 | **`id`** | `string` |  |
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request |
  | 1 | **`namespace`** | `string` |  |
  | 5 | **`spec`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec` | Note: Rule ID and expiration date are not used in the trigger request. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :rule, 0

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :id, 4, type: :string, oneof: 0
  field :spec, 5, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec, oneof: 0
  field :identity, 3, type: :string
end
