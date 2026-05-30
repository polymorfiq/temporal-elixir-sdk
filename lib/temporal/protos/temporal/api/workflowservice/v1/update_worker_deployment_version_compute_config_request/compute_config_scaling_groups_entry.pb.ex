defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest.ComputeConfigScalingGroupsEntry do
  @moduledoc """
  Used to update the compute config of a Worker Deployment Version.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupUpdate` | Required. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupUpdate
end
