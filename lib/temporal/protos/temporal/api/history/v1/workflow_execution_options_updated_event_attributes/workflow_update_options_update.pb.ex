defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes.WorkflowUpdateOptionsUpdate do
  @moduledoc """
  Automatically generated module for WorkflowUpdateOptionsUpdate

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`attached_completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Request ID attached to the running workflow execution so that subsequent requests with same |
  | 2 | **`attached_request_id`** | `string` | Versioning override removed in this event. |
  | 1 | **`update_id`** | `string` | Versioning override upserted in this event. |

  ### Additional Notes

    * `attached_completion_callbacks` (`Temporal.Protos.Temporal.Api.Common.V1.Callback`): Request ID attached to the running workflow execution so that subsequent requests with same
      request ID will be deduped.
    * `update_id` (`string`): Versioning override upserted in this event.
      Ignored if nil or if unset_versioning_override is true.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :update_id, 1, type: :string, json_name: "updateId"
  field :attached_request_id, 2, type: :string, json_name: "attachedRequestId"

  field :attached_completion_callbacks, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "attachedCompletionCallbacks"
end
