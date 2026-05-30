defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledRequest do
  @moduledoc """
  Automatically generated module for RespondActivityTaskCanceledRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | Deployment info of the worker that completed this task. Must be present if user has set |
  | 7 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that user has set in the worker. |
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized additional information to attach to the cancellation |
  | 3 | **`identity`** | `string` | The identity of the worker/client |
  | 4 | **`namespace`** | `string` |  |
  | 8 | **`resource_id`** | `string` | Resource ID for routing. Contains the workflow ID or activity ID for standalone activities. |
  | 1 | **`task_token`** | `bytes` | The task token as received in `PollActivityTaskQueueResponse` |
  | 5 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this task. This message's `build_id` field should |

  ### Additional Notes

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
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 3, type: :string
  field :namespace, 4, type: :string
  field :resource_id, 8, type: :string, json_name: "resourceId"

  field :worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true

  field :deployment, 6,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :deployment_options, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
end
