defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:operation, 0)

  field(:namespace, 1, type: :string)
  field(:task_queue, 2, type: :string, json_name: "taskQueue")

  field(:add_new_build_id_in_new_default_set, 3,
    type: :string,
    json_name: "addNewBuildIdInNewDefaultSet",
    oneof: 0
  )

  field(:add_new_compatible_build_id, 4,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.AddNewCompatibleVersion,
    json_name: "addNewCompatibleBuildId",
    oneof: 0
  )

  field(:promote_set_by_build_id, 5, type: :string, json_name: "promoteSetByBuildId", oneof: 0)

  field(:promote_build_id_within_set, 6,
    type: :string,
    json_name: "promoteBuildIdWithinSet",
    oneof: 0
  )

  field(:merge_sets, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets,
    json_name: "mergeSets",
    oneof: 0
  )
end
