defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateActivityOptions do
  @moduledoc """
  BatchOperationUpdateActivityOptions sends an update-activity-options requests in a batch.
  NOTE: keep in sync with temporal.api.workflowservice.v1.UpdateActivityRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_options`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions` | Update Activity options. Partial updates are accepted and controlled by update_mask. |
  | 1 | **`identity`** | `string` | The identity of the worker/client. |
  | 3 | **`match_all`** | `bool` |  |
  | 6 | **`restore_original`** | `bool` | If set, the activity options will be restored to the default. |
  | 2 | **`type`** | `string` |  |
  | 5 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `activity_options` will be applied |

  ### Additional Notes

    * `restore_original` (`bool`): If set, the activity options will be restored to the default.
      Default options are then options activity was created with.
      They are part of the first ActivityTaskScheduled event.
      This flag cannot be combined with any other option; if you supply
      restore_original together with other options, the request will be rejected.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :identity, 1, type: :string
  field :type, 2, type: :string, oneof: 0
  field :match_all, 3, type: :bool, json_name: "matchAll", oneof: 0

  field :activity_options, 4,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"

  field :update_mask, 5, type: Google.Protobuf.FieldMask, json_name: "updateMask"
  field :restore_original, 6, type: :bool, json_name: "restoreOriginal"
end
