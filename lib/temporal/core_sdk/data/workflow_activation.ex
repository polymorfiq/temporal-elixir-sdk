defmodule Temporal.CoreSdk.Data.WorkflowActivation do
  defstruct [
    :run_id,
    :is_replaying,
    :history_length,
    :jobs,
    :available_internal_flags,
    :history_size_bytes,
    :continue_as_new_suggested,
    :last_sdk_version,
    :suggest_continue_as_new_reasons,
    :target_worker_deployment_version_changed,
    timestamp: nil,
    deployment_version_for_current_task: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          run_id: String.t(),
          timestamp: Data.Timestamp.t() | nil,
          is_replaying: bool(),
          history_length: pos_integer(),
          jobs: [Data.WorkflowActivationJob.t()],
          available_internal_flags: [pos_integer()],
          history_size_bytes: pos_integer(),
          continue_as_new_suggested: bool(),
          deployment_version_for_current_task: Data.WorkflowDeploymentVersion.t() | nil,
          last_sdk_version: String.t(),
          suggest_continue_as_new_reasons: [integer()],
          target_worker_deployment_version_changed: bool()
        }
end
