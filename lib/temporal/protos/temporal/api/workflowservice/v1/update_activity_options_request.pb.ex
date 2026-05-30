defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityOptionsRequest do
  @moduledoc """
  NOTE: keep in sync with temporal.api.batch.v1.BatchOperationUpdateActivityOptions
  Deprecated. Use `UpdateActivityExecutionOptionsRequest`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_options`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions` | Activity options. Partial updates are accepted and controlled by update_mask |
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Execution info of the workflow which scheduled this activity |
  | 6 | **`id`** | `string` | Only activity with this ID will be updated. |
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request |
  | 9 | **`match_all`** | `bool` | Update all running activities. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity |
  | 8 | **`restore_original`** | `bool` | If set, the activity options will be restored to the default. |
  | 7 | **`type`** | `string` | Update all running activities of this type. |
  | 5 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `activity_options` will be applied |

  ### Additional Notes

    * `restore_original` (`bool`): If set, the activity options will be restored to the default.
      Default options are then options activity was created with.
      They are part of the first schedule event.
      This flag cannot be combined with any other option; if you supply
      restore_original together with other options, the request will be rejected.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :identity, 3, type: :string

  field :activity_options, 4,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"

  field :update_mask, 5, type: Google.Protobuf.FieldMask, json_name: "updateMask"
  field :id, 6, type: :string, oneof: 0
  field :type, 7, type: :string, oneof: 0
  field :match_all, 9, type: :bool, json_name: "matchAll", oneof: 0
  field :restore_original, 8, type: :bool, json_name: "restoreOriginal"
end
