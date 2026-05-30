defmodule Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade do
  @moduledoc """
  Wrapper for a target deployment version that the SDK declined to upgrade to.
  See declined_target_version_upgrade on WorkflowExecutionStartedEventAttributes.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` |  |
  | 2 | **`revision_number`** | `int64` | Revision number of the task queue routing config at the time the target |

  ### Additional Notes

    * `revision_number` (`int64`): Revision number of the task queue routing config at the time the target
      was declined. If an incoming target's revision is <= this value, it is
      not newer and is not used for deciding whether or not to suppress the
      upgrade signal.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment_version, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :revision_number, 2, type: :int64, json_name: "revisionNumber"
end
