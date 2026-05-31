defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentVersionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:compute_config, 4,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig,
    json_name: "computeConfig"
  )

  field(:identity, 3, type: :string)
  field(:request_id, 5, type: :string, json_name: "requestId")
end
