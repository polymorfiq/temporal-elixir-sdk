defmodule TemporalEngineNif.Data.WorkerDeploymentVersion do
  defstruct [
    :build_id,
    :deployment_name
  ]

  import TemporalEngine.Client

  alias TemporalEngine.Client

  @type t :: %__MODULE__{build_id: String.t(), deployment_name: String.t()}

  @spec to_record(t() | nil) :: Client.version() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{build_id: build_id, deployment_name: deployment_name}) do
    version(build_id: build_id, deployment_name: deployment_name)
  end
end
