defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:trigger, 0)

  field(:id, 1, type: :string)

  field(:activity_start, 2,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec.ActivityStartingTrigger,
    json_name: "activityStart",
    oneof: 0
  )

  field(:visibility_query, 3, type: :string, json_name: "visibilityQuery")

  field(:actions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction
  )

  field(:expiration_time, 5, type: Google.Protobuf.Timestamp, json_name: "expirationTime")
end
