defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledByIdRequest do
  @moduledoc """
  Automatically generated module for RespondActivityTaskCanceledByIdRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_id`** | `string` | Id of the activity to confirm is cancelled |
  | 7 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that user has set in the worker. |
  | 5 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized additional information to attach to the cancellation |
  | 6 | **`identity`** | `string` | The identity of the worker/client |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity |
  | 8 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:workflow_id" or "activity:activity_id" for standalone activities. |
  | 3 | **`run_id`** | `string` | For a workflow activity - the run ID of the workflow which scheduled this activity. |
  | 2 | **`workflow_id`** | `string` | Id of the workflow which scheduled this activity, leave empty to target a standalone activity |

  ### Additional Notes

    * `run_id` (`string`): For a workflow activity - the run ID of the workflow which scheduled this activity.
      For a standalone activity - the run ID of the activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :activity_id, 4, type: :string, json_name: "activityId"
  field :details, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 6, type: :string

  field :deployment_options, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"

  field :resource_id, 8, type: :string, json_name: "resourceId"
end
