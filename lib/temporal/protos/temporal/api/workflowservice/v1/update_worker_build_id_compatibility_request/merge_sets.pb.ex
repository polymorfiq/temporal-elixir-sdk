defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:primary_set_build_id, 1, type: :string, json_name: "primarySetBuildId")
  field(:secondary_set_build_id, 2, type: :string, json_name: "secondarySetBuildId")
end
