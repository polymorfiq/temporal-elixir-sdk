defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for UnpauseActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`activity_id`** | `string` | The ID of the activity to target. |
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 9 | **`jitter`** | `Google.Protobuf.Duration` | If set, the activity will start at a random time within the specified jitter duration. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 8 | **`reason`** | `string` | Reason to unpause the activity. |
  | 6 | **`reset_attempts`** | `bool` | Providing this flag will also reset the number of attempts. |
  | 7 | **`reset_heartbeat`** | `bool` | Providing this flag will also reset the heartbeat details. |
  | 10 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:{workflow_id}" for workflow activities or "activity:{activity_id}" for standalone activities. |
  | 4 | **`run_id`** | `string` | Run ID of the workflow or standalone activity. |
  | 2 | **`workflow_id`** | `string` | If provided, targets a workflow activity for the given workflow ID. |

  ### Additional Notes

    * `workflow_id` (`string`): If provided, targets a workflow activity for the given workflow ID.
      If empty, targets a standalone activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :activity_id, 3, type: :string, json_name: "activityId"
  field :run_id, 4, type: :string, json_name: "runId"
  field :identity, 5, type: :string
  field :reset_attempts, 6, type: :bool, json_name: "resetAttempts"
  field :reset_heartbeat, 7, type: :bool, json_name: "resetHeartbeat"
  field :reason, 8, type: :string
  field :jitter, 9, type: Google.Protobuf.Duration
  field :resource_id, 10, type: :string, json_name: "resourceId"
end
