defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_id, 1, type: :string, json_name: "buildId")
  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
end
