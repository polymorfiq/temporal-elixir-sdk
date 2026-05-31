defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeDeploymentRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:deployment, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment)
end
