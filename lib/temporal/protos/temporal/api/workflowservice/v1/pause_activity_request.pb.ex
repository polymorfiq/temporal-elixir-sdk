defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityRequest do
  @moduledoc """
  Deprecated. Use `PauseActivityExecutionRequest`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Execution info of the workflow which scheduled this activity |
  | 4 | **`id`** | `string` | Only the activity with this ID will be paused. |
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity. |
  | 6 | **`reason`** | `string` | Reason to pause the activity. |
  | 7 | **`request_id`** | `string` | Used to de-dupe pause requests. |
  | 5 | **`type`** | `string` | Pause all running activities of this type. |

  ### Additional Notes

    * `type` (`string`): Pause all running activities of this type.
      Note: Experimental - the behavior of pause by activity type might change in a future release.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :activity, 0

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :identity, 3, type: :string
  field :id, 4, type: :string, oneof: 0
  field :type, 5, type: :string, oneof: 0
  field :reason, 6, type: :string
  field :request_id, 7, type: :string, json_name: "requestId"
end
