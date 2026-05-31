defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:next_page_token, 1, type: :bytes, json_name: "nextPageToken")

  field(:deployments, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentListInfo
  )
end
