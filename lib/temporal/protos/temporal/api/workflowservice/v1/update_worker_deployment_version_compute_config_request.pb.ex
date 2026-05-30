defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest do
  @moduledoc """
  Used to update the compute config of a Worker Deployment Version.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`compute_config_scaling_groups`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest.ComputeConfigScalingGroupsEntry` | Optional. Contains the compute config scaling groups to add or update for the Worker |
  | 2 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 3 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 7 | **`remove_compute_config_scaling_groups`** | `string` | Optional. Contains the compute config scaling groups to remove from the Worker Deployment. |
  | 4 | **`request_id`** | `string` | A unique identifier for this create request for idempotence. Typically UUIDv4. |

  ### Additional Notes

    * `compute_config_scaling_groups` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest.ComputeConfigScalingGroupsEntry`): Optional. Contains the compute config scaling groups to add or update for the Worker
      Deployment.
    * `request_id` (`string`): A unique identifier for this create request for idempotence. Typically UUIDv4.
      If a second request with the same ID is recieved, it is considered a successful no-op.
      Retrying with a different request ID for the same deployment name + build ID is an error.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :compute_config_scaling_groups, 6,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest.ComputeConfigScalingGroupsEntry,
    json_name: "computeConfigScalingGroups",
    map: true

  field :remove_compute_config_scaling_groups, 7,
    repeated: true,
    type: :string,
    json_name: "removeComputeConfigScalingGroups"

  field :identity, 3, type: :string
  field :request_id, 4, type: :string, json_name: "requestId"
end
