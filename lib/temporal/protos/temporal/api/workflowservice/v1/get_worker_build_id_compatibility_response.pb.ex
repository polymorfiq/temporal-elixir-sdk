defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerBuildIdCompatibilityResponse do
  @moduledoc """
  [cleanup-wv-pre-release]

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`major_version_sets`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet` | Major version sets, in order from oldest to newest. The last element of the list will always |

  ### Additional Notes

    * `major_version_sets` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet`): Major version sets, in order from oldest to newest. The last element of the list will always
      be the current default major version. IE: New workflows will target the most recent version
      in that version set.

      There may be fewer sets returned than exist, if the request chose to limit this response.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :major_version_sets, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet,
    json_name: "majorVersionSets"
end
