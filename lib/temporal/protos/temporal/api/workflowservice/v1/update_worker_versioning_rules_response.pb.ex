defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:assignment_rules, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedBuildIdAssignmentRule,
    json_name: "assignmentRules"
  )

  field(:compatible_redirect_rules, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedCompatibleBuildIdRedirectRule,
    json_name: "compatibleRedirectRules"
  )

  field(:conflict_token, 3, type: :bytes, json_name: "conflictToken")
end
