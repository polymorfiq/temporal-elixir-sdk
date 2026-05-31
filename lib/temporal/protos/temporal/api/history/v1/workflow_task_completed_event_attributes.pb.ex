defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskCompletedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")
  field(:identity, 3, type: :string)
  field(:binary_checksum, 4, type: :string, json_name: "binaryChecksum", deprecated: true)

  field(:worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:sdk_metadata, 6,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata,
    json_name: "sdkMetadata"
  )

  field(:metering_metadata, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata,
    json_name: "meteringMetadata"
  )

  field(:deployment, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:versioning_behavior, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    json_name: "versioningBehavior",
    enum: true
  )

  field(:worker_deployment_version, 9,
    type: :string,
    json_name: "workerDeploymentVersion",
    deprecated: true
  )

  field(:worker_deployment_name, 10, type: :string, json_name: "workerDeploymentName")

  field(:deployment_version, 11,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )
end
