defmodule Temporal.Worker.DeploymentVersion do
  defstruct [:deployment_name, :build_id]

  @type t :: %{
          deployment_name: String.t(),
          build_id: String.t()
        }
end
