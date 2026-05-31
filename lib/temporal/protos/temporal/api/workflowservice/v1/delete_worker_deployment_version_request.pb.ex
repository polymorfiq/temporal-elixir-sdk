defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentVersionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:version, 2, type: :string, deprecated: true)

  field(:deployment_version, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:skip_drainage, 3, type: :bool, json_name: "skipDrainage")
  field(:identity, 4, type: :string)
end
