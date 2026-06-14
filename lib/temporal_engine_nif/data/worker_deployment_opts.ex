defmodule TemporalEngineNif.Data.WorkerDeploymentOpts do
  defstruct [
    :version,
    :use_worker_versioning,
    default_versioning_behavior: nil
  ]

  alias TemporalEngineNif.Data.WorkerDeploymentVersion

  @type t :: %__MODULE__{
          version: WorkerDeploymentVersion.t(),
          use_worker_versioning: bool(),
          default_versioning_behavior: pos_integer() | nil
        }

  @type opts() :: [
          {:use_worker_versioning, bool()}
          | {:default_versioning_behavior, pos_integer()}
          | {:version, WorkerDeploymentVersion.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    deployment = struct!(__MODULE__, opts)

    deployment =
      update_in(
        deployment,
        [Access.key(:version)],
        &WorkerDeploymentVersion.with_opts!/1
      )

    deployment
  end
end
