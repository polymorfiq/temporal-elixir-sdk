defmodule TemporalEngine.Data.Activation do
  require Record

  alias TemporalEngine.Data.Timestamp
  alias TemporalEngine.Data.Jobs

  Record.defrecord(:activation, [
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
  ])

  @type activation ::
          record(:activation,
            timestamp: Timestamp.timestamp(),
            is_replaying: bool(),
            history_length: pos_integer(),
            jobs: [Jobs.job()],
            available_internal_flags: [pos_integer()],
            history_size_bytes: pos_integer(),
            continue_as_new_suggested: bool(),
            deployment_version_for_current_task: version(),
            last_sdk_version: String.t(),
            suggest_continue_as_new_reasons: [continue_as_new_reason()],
            target_worker_deployment_version_changed: bool()
          )

  @type continue_as_new_reason ::
          :unspecified | :history_size_too_large | :too_many_history_events | :too_many_updates

  Record.defrecord(:version, [:build_id, :deployment_name])
  @type version :: record(:version, build_id: String.t(), deployment_name: String.t())
end
