defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.AddNewCompatibleVersion do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:new_build_id, 1, type: :string, json_name: "newBuildId")
  field(:existing_compatible_build_id, 2, type: :string, json_name: "existingCompatibleBuildId")
  field(:make_set_default, 3, type: :bool, json_name: "makeSetDefault")
end
