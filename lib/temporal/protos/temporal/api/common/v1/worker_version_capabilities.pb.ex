defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities do
  @moduledoc """
  Identifies the version that a worker is compatible with when polling or identifying itself,
  and whether or not this worker is opting into the build-id based versioning feature. This is
  used by matching to determine which workers ought to receive what tasks.
  Deprecated. Use WorkerDeploymentOptions instead.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_id`** | `string` | An opaque whole-worker identifier |
  | 4 | **`deployment_series_name`** | `string` | Must be sent if user has set a deployment series name (versioning-3). |
  | 2 | **`use_versioning`** | `bool` | If set, the worker is opting in to worker versioning, and wishes to only receive appropriate |

  ### Additional Notes

    * `use_versioning` (`bool`): If set, the worker is opting in to worker versioning, and wishes to only receive appropriate
      tasks.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id, 1, type: :string, json_name: "buildId"
  field :use_versioning, 2, type: :bool, json_name: "useVersioning"
  field :deployment_series_name, 4, type: :string, json_name: "deploymentSeriesName"
end
