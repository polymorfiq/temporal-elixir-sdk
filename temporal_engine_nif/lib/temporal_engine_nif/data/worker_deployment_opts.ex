defmodule TemporalEngineNif.Data.WorkerDeploymentOpts do
  defstruct [
    :version,
    :use_worker_versioning,
    default_versioning_behavior: nil
  ]

  alias TemporalEngine.Data.Common.WorkerDeploymentVersion

  @type t :: %__MODULE__{
          version: WorkerDeploymentVersion.t(),
          use_worker_versioning: bool(),
          default_versioning_behavior: pos_integer() | nil
        }
end
