defmodule Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition do
  @moduledoc """
  Holds information about ongoing transition of a workflow execution from one worker
  deployment version to another.
  Experimental. Might change in the future.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The target Version of the transition. |
  | 1 | **`version`** | `string` | Deprecated. Use `deployment_version`. |

  ### Additional Notes

    * `deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The target Version of the transition.
      If nil, a so-far-versioned workflow is transitioning to unversioned workers.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :version, 1, type: :string, deprecated: true

  field :deployment_version, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
end
