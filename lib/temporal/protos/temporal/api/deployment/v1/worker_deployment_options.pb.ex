defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment_name, 1, type: :string, json_name: "deploymentName")
  field(:build_id, 2, type: :string, json_name: "buildId")

  field(:worker_versioning_mode, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerVersioningMode,
    json_name: "workerVersioningMode",
    enum: true
  )
end
