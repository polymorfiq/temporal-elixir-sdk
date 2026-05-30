defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUnpauseActivities do
  @moduledoc """
  BatchOperationUnpauseActivities sends unpause requests to batch workflows.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker/client. |
  | 6 | **`jitter`** | `Google.Protobuf.Duration` | If set, the activity will start at a random time within the specified jitter |
  | 3 | **`match_all`** | `bool` |  |
  | 4 | **`reset_attempts`** | `bool` | Setting this flag will also reset the number of attempts. |
  | 5 | **`reset_heartbeat`** | `bool` | Setting this flag will also reset the heartbeat details. |
  | 2 | **`type`** | `string` |  |

  ### Additional Notes

    * `jitter` (`Google.Protobuf.Duration`): If set, the activity will start at a random time within the specified jitter
      duration, introducing variability to the start time.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :identity, 1, type: :string
  field :type, 2, type: :string, oneof: 0
  field :match_all, 3, type: :bool, json_name: "matchAll", oneof: 0
  field :reset_attempts, 4, type: :bool, json_name: "resetAttempts"
  field :reset_heartbeat, 5, type: :bool, json_name: "resetHeartbeat"
  field :jitter, 6, type: Google.Protobuf.Duration
end
