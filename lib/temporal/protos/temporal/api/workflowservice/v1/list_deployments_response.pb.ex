defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsResponse do
  @moduledoc """
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployments`** | `Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentListInfo` |  |
  | 1 | **`next_page_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :next_page_token, 1, type: :bytes, json_name: "nextPageToken"

  field :deployments, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentListInfo
end
