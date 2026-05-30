defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowRuleRequest do
  @moduledoc """
  Automatically generated module for DeleteWorkflowRuleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`rule_id`** | `string` | ID of the rule to delete. Unique within the namespace. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :rule_id, 2, type: :string, json_name: "ruleId"
end
