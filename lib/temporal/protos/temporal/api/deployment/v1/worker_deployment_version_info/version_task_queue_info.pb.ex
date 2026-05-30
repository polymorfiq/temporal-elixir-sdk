defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo do
  @moduledoc """
  A Worker Deployment Version (Version, for short) represents all workers of the same
  code and config within a Deployment. Workers of the same Version are expected to
  behave exactly the same so when executions move between them there are no
  non-determinism issues.
  Worker Deployment Versions are created in Temporal server automatically when
  their first poller arrives to the server.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`name`** | `string` | Deprecated. Use `deployment_version`. |
  | 2 | **`type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | The status of the Worker Deployment Version. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :type, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType, enum: true
end
