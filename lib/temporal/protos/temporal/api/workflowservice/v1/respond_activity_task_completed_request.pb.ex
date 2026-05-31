defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:result, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 3, type: :string)
  field(:namespace, 4, type: :string)
  field(:resource_id, 8, type: :string, json_name: "resourceId")

  field(:worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:deployment, 6,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:deployment_options, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )
end
