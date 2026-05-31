defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:commands, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Command.V1.Command)
  field(:identity, 3, type: :string)

  field(:sticky_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes,
    json_name: "stickyAttributes"
  )

  field(:return_new_workflow_task, 5, type: :bool, json_name: "returnNewWorkflowTask")
  field(:force_create_new_workflow_task, 6, type: :bool, json_name: "forceCreateNewWorkflowTask")
  field(:binary_checksum, 7, type: :string, json_name: "binaryChecksum", deprecated: true)

  field(:query_results, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.QueryResultsEntry,
    json_name: "queryResults",
    map: true
  )

  field(:namespace, 9, type: :string)
  field(:resource_id, 18, type: :string, json_name: "resourceId")

  field(:worker_version_stamp, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersionStamp",
    deprecated: true
  )

  field(:messages, 11, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message)

  field(:sdk_metadata, 12,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata,
    json_name: "sdkMetadata"
  )

  field(:metering_metadata, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata,
    json_name: "meteringMetadata"
  )

  field(:capabilities, 14,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.Capabilities
  )

  field(:deployment, 15,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:versioning_behavior, 16,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    json_name: "versioningBehavior",
    enum: true
  )

  field(:deployment_options, 17,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )

  field(:worker_instance_key, 19, type: :string, json_name: "workerInstanceKey")
  field(:worker_control_task_queue, 20, type: :string, json_name: "workerControlTaskQueue")
end
