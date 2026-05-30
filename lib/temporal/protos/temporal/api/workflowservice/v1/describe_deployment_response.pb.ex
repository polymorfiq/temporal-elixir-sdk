defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeDeploymentResponse do
  @moduledoc """
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`deployment_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment_info, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo,
    json_name: "deploymentInfo"
end
