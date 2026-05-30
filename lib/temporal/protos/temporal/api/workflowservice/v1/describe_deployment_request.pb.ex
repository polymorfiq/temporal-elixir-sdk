defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeDeploymentRequest do
  @moduledoc """
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` |  |
  | 1 | **`namespace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment
end
