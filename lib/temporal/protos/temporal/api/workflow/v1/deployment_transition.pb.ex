defmodule Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment)
end
