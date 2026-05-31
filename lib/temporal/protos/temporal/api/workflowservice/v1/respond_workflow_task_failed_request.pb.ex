defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskFailedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")

  field(:cause, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause,
    enum: true
  )

  field(:failure, 3, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:identity, 4, type: :string)
  field(:binary_checksum, 5, type: :string, json_name: "binaryChecksum", deprecated: true)
  field(:namespace, 6, type: :string)
  field(:resource_id, 11, type: :string, json_name: "resourceId")
  field(:messages, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message)

  field(:worker_version, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:deployment, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:deployment_options, 10,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )
end
