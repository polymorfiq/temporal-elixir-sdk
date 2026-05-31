defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentRampingVersionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:conflict_token, 1, type: :bytes, json_name: "conflictToken")
  field(:previous_version, 2, type: :string, json_name: "previousVersion", deprecated: true)

  field(:previous_deployment_version, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "previousDeploymentVersion",
    deprecated: true
  )

  field(:previous_percentage, 3, type: :float, json_name: "previousPercentage", deprecated: true)
end
