defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:conflict_token, 1, type: :bytes, json_name: "conflictToken")

  field(:worker_deployment_info, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo,
    json_name: "workerDeploymentInfo"
  )
end
