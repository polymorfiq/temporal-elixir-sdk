defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceCompatibleBuildIdRedirectRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rule, 1, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleBuildIdRedirectRule)
end
