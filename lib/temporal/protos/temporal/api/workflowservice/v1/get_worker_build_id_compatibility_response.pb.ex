defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerBuildIdCompatibilityResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:major_version_sets, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet,
    json_name: "majorVersionSets"
  )
end
