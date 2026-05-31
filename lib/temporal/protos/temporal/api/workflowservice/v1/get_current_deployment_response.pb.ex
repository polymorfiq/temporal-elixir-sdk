defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetCurrentDeploymentResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current_deployment_info, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo,
    json_name: "currentDeploymentInfo"
  )
end
