defmodule Temporal.Worker.WorkerAddress do
  defstruct [
    :namespace,
    :instance_key,
    :identity,
    :task_queue,
    :deployment_version,
    :grouping_key
  ]

  alias Temporal.Worker.DeploymentVersion

  @type t :: %__MODULE__{
          namespace: String.t(),
          instance_key: String.t(),
          identity: String.t(),
          task_queue: String.t(),
          deployment_version: DeploymentVersion.t() | nil,
          grouping_key: String.t()
        }
end
