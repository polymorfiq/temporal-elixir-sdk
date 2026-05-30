defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`add_new_build_id_in_new_default_set`** | `string` | A new build id. This operation will create a new set which will be the new overall |
  | 4 | **`add_new_compatible_build_id`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.AddNewCompatibleVersion` | Adds a new id to an existing compatible set, see sub-message definition for more. |
  | 7 | **`merge_sets`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets` | Merge two existing sets together, thus declaring all build IDs in both sets compatible |
  | 1 | **`namespace`** | `string` |  |
  | 6 | **`promote_build_id_within_set`** | `string` | Promote an existing build id within some set to be the current default for that set. |
  | 5 | **`promote_set_by_build_id`** | `string` | Promote an existing set to be the current default (if it isn't already) by targeting |
  | 2 | **`task_queue`** | `string` | Must be set, the task queue to apply changes to. Because all workers on a given task queue |

  ### Additional Notes

    * `add_new_build_id_in_new_default_set` (`string`): A new build id. This operation will create a new set which will be the new overall
      default version for the queue, with this id as its only member. This new set is
      incompatible with all previous sets/versions.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: In makes perfect sense here. --)
    * `merge_sets` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets`): Merge two existing sets together, thus declaring all build IDs in both sets compatible
      with one another. The primary set's default will become the default for the merged set.
      This is useful if you've accidentally declared a new ID as incompatible you meant to
      declare as compatible. The unusual case of incomplete replication during failover could
      also result in a split set, which this operation can repair.
    * `promote_build_id_within_set` (`string`): Promote an existing build id within some set to be the current default for that set.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: Within makes perfect sense here. --)
    * `promote_set_by_build_id` (`string`): Promote an existing set to be the current default (if it isn't already) by targeting
      an existing build id within it. This field's value is the extant build id.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: Names are hard. --)
    * `task_queue` (`string`): Must be set, the task queue to apply changes to. Because all workers on a given task queue
      must have the same set of workflow & activity implementations, there is no reason to specify
      a task queue type here.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :operation, 0

  field :namespace, 1, type: :string
  field :task_queue, 2, type: :string, json_name: "taskQueue"

  field :add_new_build_id_in_new_default_set, 3,
    type: :string,
    json_name: "addNewBuildIdInNewDefaultSet",
    oneof: 0

  field :add_new_compatible_build_id, 4,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.AddNewCompatibleVersion,
    json_name: "addNewCompatibleBuildId",
    oneof: 0

  field :promote_set_by_build_id, 5, type: :string, json_name: "promoteSetByBuildId", oneof: 0

  field :promote_build_id_within_set, 6,
    type: :string,
    json_name: "promoteBuildIdWithinSet",
    oneof: 0

  field :merge_sets, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets,
    json_name: "mergeSets",
    oneof: 0
end
