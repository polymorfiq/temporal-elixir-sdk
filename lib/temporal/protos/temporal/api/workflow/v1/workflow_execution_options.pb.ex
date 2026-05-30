defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions do
  @moduledoc """
  Automatically generated module for WorkflowExecutionOptions

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | If set, overrides the workflow's priority sent by the SDK. |
  | 3 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | Time-skipping configuration for this workflow execution. |
  | 1 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion. |

  ### Additional Notes

    * `time_skipping_config` (`Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig`): Time-skipping configuration for this workflow execution.
      If not set, the time-skipping configuration is not updated by this request;
      the existing configuration is preserved.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :versioning_override, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :priority, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :time_skipping_config, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
end
