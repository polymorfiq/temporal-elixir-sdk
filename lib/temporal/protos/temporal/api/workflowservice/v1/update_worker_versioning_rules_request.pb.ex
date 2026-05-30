defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest do
  @moduledoc """
  (-- api-linter: core::0134::request-mask-required=disabled
      aip.dev/not-precedent: UpdateNamespace RPC doesn't follow Google API format. --)
  (-- api-linter: core::0134::request-resource-required=disabled
      aip.dev/not-precedent: GetWorkerBuildIdCompatibilityRequest RPC doesn't follow Google API format. --)
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`add_compatible_redirect_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.AddCompatibleBuildIdRedirectRule` |  |
  | 10 | **`commit_build_id`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.CommitBuildId` |  |
  | 3 | **`conflict_token`** | `bytes` | A valid conflict_token can be taken from the previous |
  | 6 | **`delete_assignment_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteBuildIdAssignmentRule` |  |
  | 9 | **`delete_compatible_redirect_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteCompatibleBuildIdRedirectRule` |  |
  | 4 | **`insert_assignment_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.InsertBuildIdAssignmentRule` |  |
  | 1 | **`namespace`** | `string` |  |
  | 5 | **`replace_assignment_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceBuildIdAssignmentRule` |  |
  | 8 | **`replace_compatible_redirect_rule`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceCompatibleBuildIdRedirectRule` |  |
  | 2 | **`task_queue`** | `string` |  |

  ### Additional Notes

    * `conflict_token` (`bytes`): A valid conflict_token can be taken from the previous
      ListWorkerVersioningRulesResponse or UpdateWorkerVersioningRulesResponse.
      An invalid token will cause this request to fail, ensuring that if the rules
      for this Task Queue have been modified between the previous and current
      operation, the request will fail instead of causing an unpredictable mutation.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :operation, 0

  field :namespace, 1, type: :string
  field :task_queue, 2, type: :string, json_name: "taskQueue"
  field :conflict_token, 3, type: :bytes, json_name: "conflictToken"

  field :insert_assignment_rule, 4,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.InsertBuildIdAssignmentRule,
    json_name: "insertAssignmentRule",
    oneof: 0

  field :replace_assignment_rule, 5,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceBuildIdAssignmentRule,
    json_name: "replaceAssignmentRule",
    oneof: 0

  field :delete_assignment_rule, 6,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteBuildIdAssignmentRule,
    json_name: "deleteAssignmentRule",
    oneof: 0

  field :add_compatible_redirect_rule, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.AddCompatibleBuildIdRedirectRule,
    json_name: "addCompatibleRedirectRule",
    oneof: 0

  field :replace_compatible_redirect_rule, 8,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceCompatibleBuildIdRedirectRule,
    json_name: "replaceCompatibleRedirectRule",
    oneof: 0

  field :delete_compatible_redirect_rule, 9,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteCompatibleBuildIdRedirectRule,
    json_name: "deleteCompatibleRedirectRule",
    oneof: 0

  field :commit_build_id, 10,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.CommitBuildId,
    json_name: "commitBuildId",
    oneof: 0
end
