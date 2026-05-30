defmodule Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride do
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
  | 4 | **`auto_upgrade`** | `bool` | Override the workflow to have AutoUpgrade behavior. |
  | 1 | **`behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior` | Required. |
  | 2 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | Required if behavior is `PINNED`. Must be null if behavior is `AUTO_UPGRADE`. |
  | 3 | **`pinned`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverride` | Override the workflow to have Pinned behavior. |
  | 9 | **`pinned_version`** | `string` | Required if behavior is `PINNED`. Must be absent if behavior is not `PINNED`. |

  ### Additional Notes

    * `behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior`): Required.
      Deprecated. Use `override`.
    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): Required if behavior is `PINNED`. Must be null if behavior is `AUTO_UPGRADE`.
      Identifies the worker deployment to pin the workflow to.
      Deprecated. Use `override.pinned.version`.
    * `pinned_version` (`string`): Required if behavior is `PINNED`. Must be absent if behavior is not `PINNED`.
      Identifies the worker deployment version to pin the workflow to, in the format
      "<deployment_name>.<build_id>".
      Deprecated. Use `override.pinned.version`.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :override, 0

  field :pinned, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverride,
    oneof: 0

  field :auto_upgrade, 4, type: :bool, json_name: "autoUpgrade", oneof: 0

  field :behavior, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    enum: true,
    deprecated: true

  field :deployment, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :pinned_version, 9, type: :string, json_name: "pinnedVersion", deprecated: true
end
