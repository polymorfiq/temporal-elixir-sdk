defmodule Temporal.Protos.Temporal.Api.Deployment.V1.Deployment do
  @moduledoc """
  `Deployment` identifies a deployment of Temporal workers. The combination of deployment series
  name + build ID serves as the identifier. User can use `WorkerDeploymentOptions` in their worker
  programs to specify these values.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`build_id`** | `string` | Build ID changes with each version of the worker when the worker program code and/or config |
  | 1 | **`series_name`** | `string` | Different versions of the same worker service/application are related together by having a |

  ### Additional Notes

    * `build_id` (`string`): Build ID changes with each version of the worker when the worker program code and/or config
      changes.
    * `series_name` (`string`): Different versions of the same worker service/application are related together by having a
      shared series name.
      Out of all deployments of a series, one can be designated as the current deployment, which
      receives new workflow executions and new tasks of workflows with
      `VERSIONING_BEHAVIOR_AUTO_UPGRADE` versioning behavior.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :series_name, 1, type: :string, json_name: "seriesName"
  field :build_id, 2, type: :string, json_name: "buildId"
end
