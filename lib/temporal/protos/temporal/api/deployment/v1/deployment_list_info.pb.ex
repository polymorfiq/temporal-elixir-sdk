defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentListInfo do
  @moduledoc """
  DeploymentListInfo is an abbreviated set of fields from DeploymentInfo that's returned in
  ListDeployments.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` |  |
  | 3 | **`is_current`** | `bool` | If this deployment is the current deployment of its deployment series. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment
  field :create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :is_current, 3, type: :bool, json_name: "isCurrent"
end
