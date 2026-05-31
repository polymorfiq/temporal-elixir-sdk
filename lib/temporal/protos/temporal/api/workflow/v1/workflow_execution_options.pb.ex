defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:versioning_override, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:priority, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:time_skipping_config, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
  )
end
