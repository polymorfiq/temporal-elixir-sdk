defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for ResetActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`activity_id`** | `string` | The ID of the activity to target. |
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 8 | **`jitter`** | `Google.Protobuf.Duration` | If set, and activity is in backoff, the activity will start at a random time within the specified jitter duration. |
  | 7 | **`keep_paused`** | `bool` | If activity is paused, it will remain paused after reset |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 6 | **`reset_heartbeat`** | `bool` | Indicates that activity should reset heartbeat details. |
  | 10 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:{workflow_id}" for workflow activities or "activity:{activity_id}" for standalone activities. |
  | 9 | **`restore_original_options`** | `bool` | If set, the activity options will be restored to the defaults. |
  | 4 | **`run_id`** | `string` | Run ID of the workflow or standalone activity. |
  | 2 | **`workflow_id`** | `string` | If provided, targets a workflow activity for the given workflow ID. |

  ### Additional Notes

    * `jitter` (`Google.Protobuf.Duration`): If set, and activity is in backoff, the activity will start at a random time within the specified jitter duration.
      (unless it is paused and keep_paused is set)
    * `reset_heartbeat` (`bool`): Indicates that activity should reset heartbeat details.
      This flag will be applied only to the new instance of the activity.
    * `restore_original_options` (`bool`): If set, the activity options will be restored to the defaults.
      Default options are then options activity was created with.
      They are part of the first schedule event.
    * `workflow_id` (`string`): If provided, targets a workflow activity for the given workflow ID.
      If empty, targets a standalone activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :activity_id, 3, type: :string, json_name: "activityId"
  field :run_id, 4, type: :string, json_name: "runId"
  field :identity, 5, type: :string
  field :reset_heartbeat, 6, type: :bool, json_name: "resetHeartbeat"
  field :keep_paused, 7, type: :bool, json_name: "keepPaused"
  field :jitter, 8, type: Google.Protobuf.Duration
  field :restore_original_options, 9, type: :bool, json_name: "restoreOriginalOptions"
  field :resource_id, 10, type: :string, json_name: "resourceId"
end
