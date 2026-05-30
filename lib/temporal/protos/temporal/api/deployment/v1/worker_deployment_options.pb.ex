defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions do
  @moduledoc """
  Worker Deployment options set in SDK that need to be sent to server in every poll.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`build_id`** | `string` | The Build ID of the worker. Required when `worker_versioning_mode==VERSIONED`, in which case, |
  | 1 | **`deployment_name`** | `string` | Required when `worker_versioning_mode==VERSIONED`. |
  | 3 | **`worker_versioning_mode`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkerVersioningMode` | Required. Versioning Mode for this worker. Must be the same for all workers with the |

  ### Additional Notes

    * `build_id` (`string`): The Build ID of the worker. Required when `worker_versioning_mode==VERSIONED`, in which case,
      the worker will be part of a Deployment Version.
    * `worker_versioning_mode` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkerVersioningMode`): Required. Versioning Mode for this worker. Must be the same for all workers with the
      same `deployment_name` and `build_id` combination, across all Task Queues.
      When `worker_versioning_mode==VERSIONED`, the worker will be part of a Deployment Version.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment_name, 1, type: :string, json_name: "deploymentName"
  field :build_id, 2, type: :string, json_name: "buildId"

  field :worker_versioning_mode, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerVersioningMode,
    json_name: "workerVersioningMode",
    enum: true
end
