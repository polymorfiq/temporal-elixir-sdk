defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction do
  @moduledoc """
  Automatically generated module for WorkflowRuleAction

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_pause`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction.ActionActivityPause` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :activity_pause, 1,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction.ActionActivityPause,
    json_name: "activityPause",
    oneof: 0
end
