defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesResponse do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`assignment_rules`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedBuildIdAssignmentRule` |  |
  | 2 | **`compatible_redirect_rules`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedCompatibleBuildIdRedirectRule` |  |
  | 3 | **`conflict_token`** | `bytes` | This value can be passed back to UpdateWorkerVersioningRulesRequest to |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value can be passed back to UpdateWorkerVersioningRulesRequest to
      ensure that the rules were not modified between the two updates, which
      could lead to lost updates and other confusion.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :assignment_rules, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedBuildIdAssignmentRule,
    json_name: "assignmentRules"

  field :compatible_redirect_rules, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedCompatibleBuildIdRedirectRule,
    json_name: "compatibleRedirectRules"

  field :conflict_token, 3, type: :bytes, json_name: "conflictToken"
end
