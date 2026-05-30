defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkflowRuleRequest do
  @moduledoc """
  Automatically generated module for CreateWorkflowRuleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`description`** | `string` | Rule description.Will be stored with the rule. |
  | 3 | **`force_scan`** | `bool` | If true, the rule will be applied to the currently running workflows via batch job. |
  | 5 | **`identity`** | `string` | Identity of the actor who created the rule. Will be stored with the rule. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`request_id`** | `string` | Used to de-dupe requests. Typically should be UUID. |
  | 2 | **`spec`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec` | The rule specification . |

  ### Additional Notes

    * `force_scan` (`bool`): If true, the rule will be applied to the currently running workflows via batch job.
      If not set , the rule will only be applied when triggering condition is satisfied.
      visibility_query in the rule will be used to select the workflows to apply the rule to.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :spec, 2, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec
  field :force_scan, 3, type: :bool, json_name: "forceScan"
  field :request_id, 4, type: :string, json_name: "requestId"
  field :identity, 5, type: :string
  field :description, 6, type: :string
end
