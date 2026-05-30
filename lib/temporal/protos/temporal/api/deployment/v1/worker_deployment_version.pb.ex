defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion do
  @moduledoc """
  A Worker Deployment Version (Version, for short) represents a
  version of workers within a Worker Deployment. (see documentation of WorkerDeploymentVersionInfo)
  Version records are created in Temporal server automatically when their
  first poller arrives to the server.
  Experimental. Worker Deployment Versions are experimental and might significantly change in the future.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_id`** | `string` | A unique identifier for this Version within the Deployment it is a part of. |
  | 2 | **`deployment_name`** | `string` | Identifies the Worker Deployment this Version is part of. |

  ### Additional Notes

    * `build_id` (`string`): A unique identifier for this Version within the Deployment it is a part of.
      Not necessarily unique within the namespace.
      The combination of `deployment_name` and `build_id` uniquely identifies this
      Version within the namespace, because Deployment names are unique within a namespace.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id, 1, type: :string, json_name: "buildId"
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
end
