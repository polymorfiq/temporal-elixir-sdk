defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetCurrentDeploymentRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:deployment, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment)
  field(:identity, 3, type: :string)

  field(:update_metadata, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata,
    json_name: "updateMetadata"
  )
end
