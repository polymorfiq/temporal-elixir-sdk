defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentVersionRequest do
  @moduledoc """
  Creates a new WorkerDeploymentVersion.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`compute_config`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig` | Optional. Contains the new worker compute configuration for the Worker |
  | 2 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 3 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 5 | **`request_id`** | `string` | A unique identifier for this create request for idempotence. Typically UUIDv4. |

  ### Additional Notes

    * `compute_config` (`Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig`): Optional. Contains the new worker compute configuration for the Worker
      Deployment. Used for worker scale management.
    * `request_id` (`string`): A unique identifier for this create request for idempotence. Typically UUIDv4.
      If a second request with the same ID is recieved, it is considered a successful no-op.
      Retrying with a different request ID for the same deployment name + build ID is an error.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :compute_config, 4,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig,
    json_name: "computeConfig"

  field :identity, 3, type: :string
  field :request_id, 5, type: :string, json_name: "requestId"
end
