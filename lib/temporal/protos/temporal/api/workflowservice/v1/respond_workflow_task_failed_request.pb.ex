defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskFailedRequest do
  @moduledoc """
  Automatically generated module for RespondWorkflowTaskFailedRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`binary_checksum`** | `string` | Deprecated. Use `deployment_options` instead. |
  | 2 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause` | Why did the task fail? It's important to note that many of the variants in this enum cannot |
  | 9 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | Deployment info of the worker that completed this task. Must be present if user has set |
  | 10 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that user has set in the worker. |
  | 3 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Failure details |
  | 4 | **`identity`** | `string` | The identity of the worker/client |
  | 7 | **`messages`** | `Temporal.Protos.Temporal.Api.Protocol.V1.Message` | Protocol messages piggybacking on a WFT as a transport |
  | 6 | **`namespace`** | `string` |  |
  | 11 | **`resource_id`** | `string` | Resource ID for routing. Contains the workflow ID from the original task. |
  | 1 | **`task_token`** | `bytes` | The task token as received in `PollWorkflowTaskQueueResponse` |
  | 8 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this task. This message's `build_id` field should |

  ### Additional Notes

    * `binary_checksum` (`string`): Deprecated. Use `deployment_options` instead.
      Worker process' unique binary id
    * `cause` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause`): Why did the task fail? It's important to note that many of the variants in this enum cannot
      apply to worker responses. See the type's doc for more.
    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): Deployment info of the worker that completed this task. Must be present if user has set
      `WorkerDeploymentOptions` regardless of versioning being enabled or not.
      Deprecated. Replaced with `deployment_options`.
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this task. This message's `build_id` field should
      always be set by SDKs. Workers opting into versioning will also set the `use_versioning`
      field to true. See message docstrings for more.
      Deprecated. Use `deployment_options` instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"
  field :cause, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause, enum: true
  field :failure, 3, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :identity, 4, type: :string
  field :binary_checksum, 5, type: :string, json_name: "binaryChecksum", deprecated: true
  field :namespace, 6, type: :string
  field :resource_id, 11, type: :string, json_name: "resourceId"
  field :messages, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message

  field :worker_version, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true

  field :deployment, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :deployment_options, 10,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
end
