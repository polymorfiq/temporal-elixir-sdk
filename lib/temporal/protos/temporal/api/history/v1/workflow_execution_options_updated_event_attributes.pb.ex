defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:versioning_override, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:unset_versioning_override, 2, type: :bool, json_name: "unsetVersioningOverride")
  field(:attached_request_id, 3, type: :string, json_name: "attachedRequestId")

  field(:attached_completion_callbacks, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "attachedCompletionCallbacks"
  )

  field(:identity, 5, type: :string)
  field(:priority, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:time_skipping_config, 7,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
  )

  field(:workflow_update_options, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes.WorkflowUpdateOptionsUpdate,
    json_name: "workflowUpdateOptions"
  )
end
