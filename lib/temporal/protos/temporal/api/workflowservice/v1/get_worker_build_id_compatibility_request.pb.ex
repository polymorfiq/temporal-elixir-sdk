defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerBuildIdCompatibilityRequest do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`max_sets`** | `int32` | Limits how many compatible sets will be returned. Specify 1 to only return the current |
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`task_queue`** | `string` | Must be set, the task queue to interrogate about worker id compatibility. |

  ### Additional Notes

    * `max_sets` (`int32`): Limits how many compatible sets will be returned. Specify 1 to only return the current
      default major version set. 0 returns all sets.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :task_queue, 2, type: :string, json_name: "taskQueue"
  field :max_sets, 3, type: :int32, json_name: "maxSets"
end
