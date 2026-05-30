defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.InsertBuildIdAssignmentRule do
  @moduledoc """
  (-- api-linter: core::0134::request-mask-required=disabled
      aip.dev/not-precedent: UpdateNamespace RPC doesn't follow Google API format. --)
  (-- api-linter: core::0134::request-resource-required=disabled
      aip.dev/not-precedent: GetWorkerBuildIdCompatibilityRequest RPC doesn't follow Google API format. --)
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`rule`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule` |  |
  | 1 | **`rule_index`** | `int32` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule_index, 1, type: :int32, json_name: "ruleIndex"
  field :rule, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule
end
