defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceBuildIdAssignmentRule do
  @moduledoc """
  (-- api-linter: core::0134::request-mask-required=disabled
      aip.dev/not-precedent: UpdateNamespace RPC doesn't follow Google API format. --)
  (-- api-linter: core::0134::request-resource-required=disabled
      aip.dev/not-precedent: GetWorkerBuildIdCompatibilityRequest RPC doesn't follow Google API format. --)
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`force`** | `bool` | A valid conflict_token can be taken from the previous |
  | 2 | **`rule`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule` |  |
  | 1 | **`rule_index`** | `int32` |  |

  ### Additional Notes

    * `force` (`bool`): A valid conflict_token can be taken from the previous
      ListWorkerVersioningRulesResponse or UpdateWorkerVersioningRulesResponse.
      An invalid token will cause this request to fail, ensuring that if the rules
      for this Task Queue have been modified between the previous and current
      operation, the request will fail instead of causing an unpredictable mutation.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule_index, 1, type: :int32, json_name: "ruleIndex"
  field :rule, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule
  field :force, 3, type: :bool
end
