defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest.MergeSets do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`primary_set_build_id`** | `string` |  |
  | 2 | **`secondary_set_build_id`** | `string` | Must be set, the task queue to apply changes to. Because all workers on a given task queue |

  ### Additional Notes

    * `secondary_set_build_id` (`string`): Must be set, the task queue to apply changes to. Because all workers on a given task queue
      must have the same set of workflow & activity implementations, there is no reason to specify
      a task queue type here.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :primary_set_build_id, 1, type: :string, json_name: "primarySetBuildId"
  field :secondary_set_build_id, 2, type: :string, json_name: "secondarySetBuildId"
end
