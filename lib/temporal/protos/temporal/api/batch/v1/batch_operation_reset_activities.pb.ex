defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationResetActivities do
  @moduledoc """
  BatchOperationResetActivities sends activity reset requests in a batch.
  NOTE: keep in sync with temporal.api.workflowservice.v1.ResetActivityRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker/client. |
  | 7 | **`jitter`** | `Google.Protobuf.Duration` | If set, the activity will start at a random time within the specified jitter |
  | 6 | **`keep_paused`** | `bool` | If activity is paused, it will remain paused after reset |
  | 3 | **`match_all`** | `bool` |  |
  | 4 | **`reset_attempts`** | `bool` | Setting this flag will also reset the number of attempts. |
  | 5 | **`reset_heartbeat`** | `bool` | Setting this flag will also reset the heartbeat details. |
  | 8 | **`restore_original_options`** | `bool` | If set, the activity options will be restored to the defaults. |
  | 2 | **`type`** | `string` |  |

  ### Additional Notes

    * `jitter` (`Google.Protobuf.Duration`): If set, the activity will start at a random time within the specified jitter
      duration, introducing variability to the start time.
    * `restore_original_options` (`bool`): If set, the activity options will be restored to the defaults.
      Default options are then options activity was created with.
      They are part of the first ActivityTaskScheduled event.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :identity, 1, type: :string
  field :type, 2, type: :string, oneof: 0
  field :match_all, 3, type: :bool, json_name: "matchAll", oneof: 0
  field :reset_attempts, 4, type: :bool, json_name: "resetAttempts"
  field :reset_heartbeat, 5, type: :bool, json_name: "resetHeartbeat"
  field :keep_paused, 6, type: :bool, json_name: "keepPaused"
  field :jitter, 7, type: Google.Protobuf.Duration
  field :restore_original_options, 8, type: :bool, json_name: "restoreOriginalOptions"
end
