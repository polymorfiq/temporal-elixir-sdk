defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentRequest do
  @moduledoc """
  Automatically generated module for DescribeWorkerDeploymentRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment_name`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
end
