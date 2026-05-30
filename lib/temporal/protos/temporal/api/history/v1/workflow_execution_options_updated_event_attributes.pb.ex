defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionOptionsUpdatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`attached_completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Completion callbacks attached to the running workflow execution. |
  | 3 | **`attached_request_id`** | `string` | Request ID attached to the running workflow execution so that subsequent requests with same |
  | 5 | **`identity`** | `string` | Optional. The identity of the client who initiated the request that created this event. |
  | 6 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority override upserted in this event. Represents the full priority; not just partial fields. |
  | 7 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | If set, the time-skipping configuration was changed. Contains the full updated configuration. |
  | 2 | **`unset_versioning_override`** | `bool` | Versioning override removed in this event. |
  | 1 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | Versioning override upserted in this event. |
  | 8 | **`workflow_update_options`** | `Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes.WorkflowUpdateOptionsUpdate` | Updates to workflow updates options. |

  ### Additional Notes

    * `attached_request_id` (`string`): Request ID attached to the running workflow execution so that subsequent requests with same
      request ID will be deduped.
    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority override upserted in this event. Represents the full priority; not just partial fields.
      Ignored if nil.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): Versioning override upserted in this event.
      Ignored if nil or if unset_versioning_override is true.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :versioning_override, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :unset_versioning_override, 2, type: :bool, json_name: "unsetVersioningOverride"
  field :attached_request_id, 3, type: :string, json_name: "attachedRequestId"

  field :attached_completion_callbacks, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "attachedCompletionCallbacks"

  field :identity, 5, type: :string
  field :priority, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :time_skipping_config, 7,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"

  field :workflow_update_options, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes.WorkflowUpdateOptionsUpdate,
    json_name: "workflowUpdateOptions"
end
