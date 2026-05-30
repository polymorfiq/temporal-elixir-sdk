defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for PauseActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`activity_id`** | `string` | The ID of the activity to target. |
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 6 | **`reason`** | `string` | Reason to pause the activity. |
  | 8 | **`request_id`** | `string` | Used to de-dupe pause requests. |
  | 7 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:{workflow_id}" for workflow activities or "activity:{activity_id}" for standalone activities. |
  | 4 | **`run_id`** | `string` | Run ID of the workflow or standalone activity. |
  | 2 | **`workflow_id`** | `string` | If provided, pause a workflow activity (or activities) for the given workflow ID. |

  ### Additional Notes

    * `workflow_id` (`string`): If provided, pause a workflow activity (or activities) for the given workflow ID.
      If empty, targets a standalone activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :activity_id, 3, type: :string, json_name: "activityId"
  field :run_id, 4, type: :string, json_name: "runId"
  field :identity, 5, type: :string
  field :reason, 6, type: :string
  field :resource_id, 7, type: :string, json_name: "resourceId"
  field :request_id, 8, type: :string, json_name: "requestId"
end
