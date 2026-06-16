defmodule TemporalEngineNif.Data.WorkflowActivation do
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

  import TemporalEngine.Data.Activation

  alias TemporalEngineNif.Data.Timestamp
  alias TemporalEngineNif.Data.WorkflowActivationJob
  alias TemporalEngineNif.Data.WorkerDeploymentVersion

  @type t :: %__MODULE__{
          run_id: String.t(),
          timestamp: Timestamp.t() | nil,
          is_replaying: bool(),
          history_length: pos_integer(),
          jobs: [WorkflowActivationJob.t()],
          available_internal_flags: [pos_integer()],
          history_size_bytes: pos_integer(),
          continue_as_new_suggested: bool(),
          deployment_version_for_current_task: WorkerDeploymentVersion.t() | nil,
          last_sdk_version: String.t(),
          suggest_continue_as_new_reasons: [integer()],
          target_worker_deployment_version_changed: bool()
        }

  @spec to_record(t()) :: Activation.activation()
  def to_record(from_server) do
    activation(
      run_id: from_server.run_id,
      timestamp: from_server.timestamp |> Timestamp.to_record(),
      is_replaying: from_server.is_replaying,
      history_length: from_server.history_length,
      jobs: Enum.map(from_server.jobs, &WorkflowActivationJob.to_record/1),
      available_internal_flags: from_server.available_internal_flags,
      history_size_bytes: from_server.history_size_bytes,
      continue_as_new_suggested: from_server.continue_as_new_suggested,
      deployment_version_for_current_task:
        from_server.deployment_version_for_current_task |> WorkerDeploymentVersion.to_record(),
      last_sdk_version: from_server.last_sdk_version,
      suggest_continue_as_new_reasons: from_server.suggest_continue_as_new_reasons,
      target_worker_deployment_version_changed:
        from_server.target_worker_deployment_version_changed
    )
  end
end
