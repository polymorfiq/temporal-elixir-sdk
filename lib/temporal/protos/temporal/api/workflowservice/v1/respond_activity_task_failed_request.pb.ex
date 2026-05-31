defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:identity, 3, type: :string)
  field(:namespace, 4, type: :string)
  field(:resource_id, 9, type: :string, json_name: "resourceId")

  field(:last_heartbeat_details, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastHeartbeatDetails"
  )

  field(:worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:deployment, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:deployment_options, 8,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )
end
