defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityRequest do
  @moduledoc """
  Deprecated. Use `UnpauseActivityExecutionRequest`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Execution info of the workflow which scheduled this activity |
  | 4 | **`id`** | `string` | Only the activity with this ID will be unpaused. |
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 9 | **`jitter`** | `Google.Protobuf.Duration` | If set, the activity will start at a random time within the specified jitter duration. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 7 | **`reset_attempts`** | `bool` | Providing this flag will also reset the number of attempts. |
  | 8 | **`reset_heartbeat`** | `bool` | Providing this flag will also reset the heartbeat details. |
  | 5 | **`type`** | `string` | Unpause all running activities with of this type. |
  | 6 | **`unpause_all`** | `bool` | Unpause all running activities. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :identity, 3, type: :string
  field :id, 4, type: :string, oneof: 0
  field :type, 5, type: :string, oneof: 0
  field :unpause_all, 6, type: :bool, json_name: "unpauseAll", oneof: 0
  field :reset_attempts, 7, type: :bool, json_name: "resetAttempts"
  field :reset_heartbeat, 8, type: :bool, json_name: "resetHeartbeat"
  field :jitter, 9, type: Google.Protobuf.Duration
end
