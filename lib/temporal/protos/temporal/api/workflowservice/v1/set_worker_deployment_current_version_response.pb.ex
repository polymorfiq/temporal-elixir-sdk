defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:conflict_token, 1, type: :bytes, json_name: "conflictToken")
  field(:previous_version, 2, type: :string, json_name: "previousVersion", deprecated: true)

  field(:previous_deployment_version, 3,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "previousDeploymentVersion",
    deprecated: true
  )
end
