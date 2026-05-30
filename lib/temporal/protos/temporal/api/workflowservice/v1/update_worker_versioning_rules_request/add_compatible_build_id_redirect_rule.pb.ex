defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.AddCompatibleBuildIdRedirectRule do
  @moduledoc """
  (-- api-linter: core::0134::request-mask-required=disabled
      aip.dev/not-precedent: UpdateNamespace RPC doesn't follow Google API format. --)
  (-- api-linter: core::0134::request-resource-required=disabled
      aip.dev/not-precedent: GetWorkerBuildIdCompatibilityRequest RPC doesn't follow Google API format. --)
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`rule`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleBuildIdRedirectRule` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule, 1, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleBuildIdRedirectRule
end
