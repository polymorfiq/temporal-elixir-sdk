defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TriggerWorkflowRuleResponse do
  @moduledoc """
  Automatically generated module for TriggerWorkflowRuleResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`applied`** | `bool` | True is the rule was applied, based on the rule conditions (predicate/visibility_query). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :applied, 1, type: :bool
end
