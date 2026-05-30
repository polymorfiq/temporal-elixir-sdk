defmodule Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverride do
  @moduledoc """
  Used to override the versioning behavior (and pinned deployment version, if applicable) of a
  specific workflow execution. If set, this override takes precedence over worker-sent values.
  See `WorkflowExecutionInfo.VersioningInfo` for more information.

  To remove the override, call `UpdateWorkflowExecutionOptions` with a null
  `VersioningOverride`, and use the `update_mask` to indicate that it should be mutated.

  Pinned behavior overrides are automatically inherited by child workflows, workflow retries, continue-as-new
  workflows, and cron workflows.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`behavior`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverrideBehavior` | Override the workflow to have Pinned behavior. |
  | 2 | **`version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Override the workflow to have AutoUpgrade behavior. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :behavior, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverrideBehavior,
    enum: true

  field :version, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion
end
