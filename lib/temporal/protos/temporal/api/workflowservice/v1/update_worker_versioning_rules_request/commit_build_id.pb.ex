defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.CommitBuildId do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:target_build_id, 1, type: :string, json_name: "targetBuildId")
  field(:force, 2, type: :bool)
end
