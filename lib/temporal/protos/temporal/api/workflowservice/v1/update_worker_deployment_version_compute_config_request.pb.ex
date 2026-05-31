defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:compute_config_scaling_groups, 6,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest.ComputeConfigScalingGroupsEntry,
    json_name: "computeConfigScalingGroups",
    map: true
  )

  field(:remove_compute_config_scaling_groups, 7,
    repeated: true,
    type: :string,
    json_name: "removeComputeConfigScalingGroups"
  )

  field(:identity, 3, type: :string)
  field(:request_id, 4, type: :string, json_name: "requestId")
end
