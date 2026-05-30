defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.AddNewCompatibleVersion do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`existing_compatible_build_id`** | `string` | Must be set, the task queue to apply changes to. Because all workers on a given task queue |
  | 3 | **`make_set_default`** | `bool` | A new build id. This operation will create a new set which will be the new overall |
  | 1 | **`new_build_id`** | `string` |  |

  ### Additional Notes

    * `existing_compatible_build_id` (`string`): Must be set, the task queue to apply changes to. Because all workers on a given task queue
      must have the same set of workflow & activity implementations, there is no reason to specify
      a task queue type here.
    * `make_set_default` (`bool`): A new build id. This operation will create a new set which will be the new overall
      default version for the queue, with this id as its only member. This new set is
      incompatible with all previous sets/versions.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: In makes perfect sense here. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :new_build_id, 1, type: :string, json_name: "newBuildId"
  field :existing_compatible_build_id, 2, type: :string, json_name: "existingCompatibleBuildId"
  field :make_set_default, 3, type: :bool, json_name: "makeSetDefault"
end
