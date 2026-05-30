defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityRequest do
  @moduledoc """
  NOTE: keep in sync with temporal.api.batch.v1.BatchOperationResetActivities
  Deprecated. Use `ResetActivityExecutionRequest`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Execution info of the workflow which scheduled this activity |
  | 4 | **`id`** | `string` | Only activity with this ID will be reset. |
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 8 | **`jitter`** | `Google.Protobuf.Duration` | If set, and activity is in backoff, the activity will start at a random time within the specified jitter duration. |
  | 7 | **`keep_paused`** | `bool` | If activity is paused, it will remain paused after reset |
  | 10 | **`match_all`** | `bool` | Reset all running activities. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 6 | **`reset_heartbeat`** | `bool` | Indicates that activity should reset heartbeat details. |
  | 9 | **`restore_original_options`** | `bool` | If set, the activity options will be restored to the defaults. |
  | 5 | **`type`** | `string` | Reset all running activities with of this type. |

  ### Additional Notes

    * `jitter` (`Google.Protobuf.Duration`): If set, and activity is in backoff, the activity will start at a random time within the specified jitter duration.
      (unless it is paused and keep_paused is set)
    * `reset_heartbeat` (`bool`): Indicates that activity should reset heartbeat details.
      This flag will be applied only to the new instance of the activity.
    * `restore_original_options` (`bool`): If set, the activity options will be restored to the defaults.
      Default options are then options activity was created with.
      They are part of the first schedule event.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :identity, 3, type: :string
  field :id, 4, type: :string, oneof: 0
  field :type, 5, type: :string, oneof: 0
  field :match_all, 10, type: :bool, json_name: "matchAll", oneof: 0
  field :reset_heartbeat, 6, type: :bool, json_name: "resetHeartbeat"
  field :keep_paused, 7, type: :bool, json_name: "keepPaused"
  field :jitter, 8, type: Google.Protobuf.Duration
  field :restore_original_options, 9, type: :bool, json_name: "restoreOriginalOptions"
end
