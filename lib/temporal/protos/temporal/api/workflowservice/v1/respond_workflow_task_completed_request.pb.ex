defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest do
  @moduledoc """
  Automatically generated module for RespondWorkflowTaskCompletedRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`binary_checksum`** | `string` | Deprecated. Use `deployment_options` instead. |
  | 14 | **`capabilities`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.Capabilities` | All capabilities the SDK supports. |
  | 2 | **`commands`** | `Temporal.Protos.Temporal.Api.Command.V1.Command` | A list of commands generated when driving the workflow code in response to the new task |
  | 15 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | Deployment info of the worker that completed this task. Must be present if user has set |
  | 17 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that user has set in the worker. |
  | 6 | **`force_create_new_workflow_task`** | `bool` | Can be used to *force* creation of a new workflow task, even if no commands have resolved or |
  | 3 | **`identity`** | `string` | The identity of the worker/client |
  | 11 | **`messages`** | `Temporal.Protos.Temporal.Api.Protocol.V1.Message` | Protocol messages piggybacking on a WFT as a transport |
  | 13 | **`metering_metadata`** | `Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata` | Local usage data collected for metering |
  | 9 | **`namespace`** | `string` |  |
  | 8 | **`query_results`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.QueryResultsEntry` | Responses to the `queries` field in the task being responded to |
  | 18 | **`resource_id`** | `string` | Resource ID for routing. Contains the workflow ID from the original task. |
  | 5 | **`return_new_workflow_task`** | `bool` | If set, the worker wishes to immediately receive the next workflow task as a response to |
  | 12 | **`sdk_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata` | Data the SDK wishes to record for itself, but server need not interpret, and does not |
  | 4 | **`sticky_attributes`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes` | May be set by workers to indicate that the worker desires future tasks to be provided with |
  | 1 | **`task_token`** | `bytes` | The task token as received in `PollWorkflowTaskQueueResponse` |
  | 16 | **`versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior` | Versioning behavior of this workflow execution as set on the worker that completed this task. |
  | 20 | **`worker_control_task_queue`** | `string` | A dedicated per-worker Nexus task queue on which the server sends control |
  | 19 | **`worker_instance_key`** | `string` | A unique key for this worker instance, used for tracking worker lifecycle. |
  | 10 | **`worker_version_stamp`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this task. This message's `build_id` field should |

  ### Additional Notes

    * `binary_checksum` (`string`): Deprecated. Use `deployment_options` instead.
      Worker process' unique binary id
    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): Deployment info of the worker that completed this task. Must be present if user has set
      `WorkerDeploymentOptions` regardless of versioning being enabled or not.
      Deprecated. Replaced with `deployment_options`.
    * `force_create_new_workflow_task` (`bool`): Can be used to *force* creation of a new workflow task, even if no commands have resolved or
      one would not otherwise have been generated. This is used when the worker knows it is doing
      something useful, but cannot complete it within the workflow task timeout. Local activities
      which run for longer than the task timeout being the prime example.
    * `return_new_workflow_task` (`bool`): If set, the worker wishes to immediately receive the next workflow task as a response to
      this completion. This can save on polling round-trips.
    * `sdk_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata`): Data the SDK wishes to record for itself, but server need not interpret, and does not
      directly impact workflow state.
    * `sticky_attributes` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes`): May be set by workers to indicate that the worker desires future tasks to be provided with
      incremental history on a sticky queue.
    * `versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior`): Versioning behavior of this workflow execution as set on the worker that completed this task.
      UNSPECIFIED means versioning is not enabled in the worker.
    * `worker_control_task_queue` (`string`): A dedicated per-worker Nexus task queue on which the server sends control
      tasks (e.g. activity cancellation) to this specific worker instance.
    * `worker_instance_key` (`string`): A unique key for this worker instance, used for tracking worker lifecycle.
      This is guaranteed to be unique, whereas identity is not guaranteed to be unique.
    * `worker_version_stamp` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this task. This message's `build_id` field should
      always be set by SDKs. Workers opting into versioning will also set the `use_versioning`
      field to true. See message docstrings for more.
      Deprecated. Use `deployment_options` and `versioning_behavior` instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"
  field :commands, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Command.V1.Command
  field :identity, 3, type: :string

  field :sticky_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.StickyExecutionAttributes,
    json_name: "stickyAttributes"

  field :return_new_workflow_task, 5, type: :bool, json_name: "returnNewWorkflowTask"
  field :force_create_new_workflow_task, 6, type: :bool, json_name: "forceCreateNewWorkflowTask"
  field :binary_checksum, 7, type: :string, json_name: "binaryChecksum", deprecated: true

  field :query_results, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.QueryResultsEntry,
    json_name: "queryResults",
    map: true

  field :namespace, 9, type: :string
  field :resource_id, 18, type: :string, json_name: "resourceId"

  field :worker_version_stamp, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersionStamp",
    deprecated: true

  field :messages, 11, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message

  field :sdk_metadata, 12,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata,
    json_name: "sdkMetadata"

  field :metering_metadata, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata,
    json_name: "meteringMetadata"

  field :capabilities, 14,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.Capabilities

  field :deployment, 15,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :versioning_behavior, 16,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    json_name: "versioningBehavior",
    enum: true

  field :deployment_options, 17,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"

  field :worker_instance_key, 19, type: :string, json_name: "workerInstanceKey"
  field :worker_control_task_queue, 20, type: :string, json_name: "workerControlTaskQueue"
end
