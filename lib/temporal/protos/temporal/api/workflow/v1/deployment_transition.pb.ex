defmodule Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition do
  @moduledoc """
  Holds information about ongoing transition of a workflow execution from one deployment to another.
  Deprecated. Use DeploymentVersionTransition.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | The target deployment of the transition. Null means a so-far-versioned workflow is |

  ### Additional Notes

    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): The target deployment of the transition. Null means a so-far-versioned workflow is
      transitioning to unversioned workers.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment
end
