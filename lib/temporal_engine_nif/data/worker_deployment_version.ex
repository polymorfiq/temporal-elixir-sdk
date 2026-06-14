defmodule TemporalEngineNif.Data.WorkerDeploymentVersion do
  defstruct [
    :build_id,
    :deployment_name
  ]

  require TemporalEngine.Client

  @type t :: %__MODULE__{build_id: String.t(), deployment_name: String.t()}

  def to_record(%__MODULE__{build_id: build_id, deployment_name: deployment_name}) do
    TemporalEngine.Client.version(build_id: build_id, deployment_name: deployment_name)
  end
end
