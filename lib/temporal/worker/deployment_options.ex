defmodule Temporal.Worker.DeploymentOptions do
  alias Temporal.Worker.DeploymentVersion

  defstruct use_versioning: false,
            version: %DeploymentVersion{deployment_name: "", build_id: ""},
            default_versioning_behavior: :unspecified

  @typedoc """
  - **`:use_versioning`** (*Default: `false`*)

    If set, opts this worker into the Worker Deployment Versioning feature. It will only operate on workflows it claims to be compatible with. You must set [Version] if this flag is true.

    **NOTE:** Cannot be enabled at the same time as the worker option `:enable_session_worker`

  - **`:version`** (*Default: `nil`*)

    Assign a Deployment Version identifier to this worker.

  - **`:default_versioning_behavior`** (*Default: `:unspecified`*)

    Provides a default Versioning Behavior to workflows that do not set one with the workflow registration option `:versioning_behavior`.

    It is an error to set this without `:use_versioning` being true.

    **NOTE:** When the new Deployment-based Worker Versioning feature is on, and `:default_versioning_behavior` is `:unspecified`, workflows that do not set the Versioning Behavior will fail at registration time.
  """
  @type t() :: %__MODULE__{
          use_versioning: bool(),
          version: DeploymentVersion.t(),
          default_versioning_behavior: versioning_behavior()
        }

  @type versioning_behavior() :: :unspecified | :pinned | :auto_upgrade
end
