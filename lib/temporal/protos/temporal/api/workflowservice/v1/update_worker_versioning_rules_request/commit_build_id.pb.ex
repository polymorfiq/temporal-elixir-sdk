defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.CommitBuildId do
  @moduledoc """
  (-- api-linter: core::0134::request-mask-required=disabled
      aip.dev/not-precedent: UpdateNamespace RPC doesn't follow Google API format. --)
  (-- api-linter: core::0134::request-resource-required=disabled
      aip.dev/not-precedent: GetWorkerBuildIdCompatibilityRequest RPC doesn't follow Google API format. --)
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`force`** | `bool` |  |
  | 1 | **`target_build_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :target_build_id, 1, type: :string, json_name: "targetBuildId"
  field :force, 2, type: :bool
end
