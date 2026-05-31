defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:activity_pause, 1,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction.ActionActivityPause,
    json_name: "activityPause",
    oneof: 0
  )
end
