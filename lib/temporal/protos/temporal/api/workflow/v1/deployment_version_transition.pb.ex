defmodule Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:version, 1, type: :string, deprecated: true)

  field(:deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )
end
