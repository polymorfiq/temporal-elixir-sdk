defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo do
  @moduledoc """
  Automatically generated module for PollerInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that SDK sent to server. |
  | 2 | **`identity`** | `string` |  |
  | 1 | **`last_access_time`** | `Google.Protobuf.Timestamp` |  |
  | 3 | **`rate_per_second`** | `double` |  |
  | 4 | **`worker_version_capabilities`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities` | If a worker has opted into the worker versioning feature while polling, its capabilities will |

  ### Additional Notes

    * `worker_version_capabilities` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities`): If a worker has opted into the worker versioning feature while polling, its capabilities will
      appear here.
      Deprecated. Replaced by deployment_options.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :last_access_time, 1, type: Google.Protobuf.Timestamp, json_name: "lastAccessTime"
  field :identity, 2, type: :string
  field :rate_per_second, 3, type: :double, json_name: "ratePerSecond"

  field :worker_version_capabilities, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities,
    json_name: "workerVersionCapabilities",
    deprecated: true

  field :deployment_options, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
end
