defmodule Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo do
  @moduledoc """
  Used as part of WorkflowExecutionStartedEventAttributes to pass down the AutoUpgrade behavior and source deployment version
  to a workflow execution whose parent/previous workflow has an AutoUpgrade behavior.
  Also used for Upgrade-on-CaN behaviors AutoUpgrade and UseRampingVersion.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`continue_as_new_initial_versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior` | Experimental. |
  | 2 | **`source_deployment_revision_number`** | `int64` | The revision number of the source deployment version of the parent/previous workflow. |
  | 1 | **`source_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The source deployment version of the parent/previous workflow. |

  ### Additional Notes

    * `continue_as_new_initial_versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior`): Experimental.
      If this workflow is the result of a continue-as-new, this field is set to the initial_versioning_behavior
      specified in that command.
      Only used for the initial task of this run and the initial task of any retries of this run.
      Not passed to children or to future continue-as-new.

      Note: In the first release of Upgrade-on-CaN, when the only ContinueAsNewVersioningBehavior was AutoUpgrade,
      a non-empty InheritedAutoUpgradeInfo meant that the workflow should start as AutoUpgrade. So for compatibility
      with history events generated during that time, know that an UNSPECIFIED value here is equivalent to AutoUpgrade
      value if the InheritedAutoUpgradeInfo is non-empty.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :source_deployment_version, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "sourceDeploymentVersion"

  field :source_deployment_revision_number, 2,
    type: :int64,
    json_name: "sourceDeploymentRevisionNumber"

  field :continue_as_new_initial_versioning_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "continueAsNewInitialVersioningBehavior",
    enum: true
end
