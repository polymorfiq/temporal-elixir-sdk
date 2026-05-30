defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkflowRuleResponse do
  @moduledoc """
  Automatically generated module for CreateWorkflowRuleResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`job_id`** | `string` | Batch Job ID if force-scan flag was provided. Otherwise empty. |
  | 1 | **`rule`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule` | Created rule. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule, 1, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule
  field :job_id, 2, type: :string, json_name: "jobId"
end
