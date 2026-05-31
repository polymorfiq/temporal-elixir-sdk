defmodule Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment_version, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:revision_number, 2, type: :int64, json_name: "revisionNumber")
end
