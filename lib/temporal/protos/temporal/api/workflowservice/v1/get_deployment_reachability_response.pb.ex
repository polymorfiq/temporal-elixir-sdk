defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetDeploymentReachabilityResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment_info, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo,
    json_name: "deploymentInfo"
  )

  field(:reachability, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.DeploymentReachability,
    enum: true
  )

  field(:last_update_time, 3, type: Google.Protobuf.Timestamp, json_name: "lastUpdateTime")
end
