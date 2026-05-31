defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleBuildIdRedirectRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:source_build_id, 1, type: :string, json_name: "sourceBuildId")
  field(:target_build_id, 2, type: :string, json_name: "targetBuildId")
end
