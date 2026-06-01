defmodule Temporal.CoreSdk.Data.WorkerDeploymentVersion do
  defstruct [
    :build_id,
    :deployment_name
  ]

  @type t :: %__MODULE__{build_id: String.t(), deployment_name: String.t()}
end
