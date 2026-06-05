defmodule Temporal.CoreSdk.Data.WorkerDeploymentVersion do
  defstruct [
    :build_id,
    :deployment_name
  ]

  @type t :: %__MODULE__{build_id: String.t(), deployment_name: String.t()}
  @type opts() :: [{:build_id, String.t()}, {:deployment_name, String.t()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
