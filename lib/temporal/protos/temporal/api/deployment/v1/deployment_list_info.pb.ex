defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentListInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment)
  field(:create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime")
  field(:is_current, 3, type: :bool, json_name: "isCurrent")
end
