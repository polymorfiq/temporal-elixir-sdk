defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
  field(:identity, 3, type: :string)
end
