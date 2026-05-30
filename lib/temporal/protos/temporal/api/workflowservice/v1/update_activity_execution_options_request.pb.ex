defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityExecutionOptionsRequest do
  @moduledoc """
  Automatically generated module for UpdateActivityExecutionOptionsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`activity_id`** | `string` | The ID of the activity to target. |
  | 6 | **`activity_options`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions` | Activity options. Partial updates are accepted and controlled by update_mask |
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity |
  | 9 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:{workflow_id}" for workflow activities or "activity:{activity_id}" for standalone activities. |
  | 8 | **`restore_original`** | `bool` | If set, the activity options will be restored to the default. |
  | 4 | **`run_id`** | `string` | Run ID of the workflow or standalone activity. |
  | 7 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `activity_options` will be applied |
  | 2 | **`workflow_id`** | `string` | If provided, targets a workflow activity for the given workflow ID. |

  ### Additional Notes

    * `restore_original` (`bool`): If set, the activity options will be restored to the default.
      Default options are then options activity was created with.
      They are part of the first schedule event.
      This flag cannot be combined with any other option; if you supply
      restore_original together with other options, the request will be rejected.
    * `workflow_id` (`string`): If provided, targets a workflow activity for the given workflow ID.
      If empty, targets a standalone activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :activity_id, 3, type: :string, json_name: "activityId"
  field :run_id, 4, type: :string, json_name: "runId"
  field :identity, 5, type: :string

  field :activity_options, 6,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"

  field :update_mask, 7, type: Google.Protobuf.FieldMask, json_name: "updateMask"
  field :restore_original, 8, type: :bool, json_name: "restoreOriginal"
  field :resource_id, 9, type: :string, json_name: "resourceId"
end
