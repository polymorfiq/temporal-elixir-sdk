defmodule TemporalEngine.Data.ActivationCompletion do
  require Record
  alias TemporalEngine.Data.Commands

  Record.defrecord(:completion, [:run_id, :result])
  @type completion :: record(:completion, run_id: String.t(), result: success() | failure())

  Record.defrecord(:success, [
    :commands,
    used_internal_flags: [],
    versioning_behavior: :unspecified
  ])

  @type success ::
          record(:success,
            commands: [Commands.command()],
            used_internal_flags: [pos_integer()],
            versioning_behavior: versioning_behavior()
          )

  @type versioning_behavior :: :unspecified | :pinned | :auto_upgrade

  Record.defrecord(:failure, cause: :unspecified, failure: nil)
  @type failure :: record(:failure, cause: cause(), failure: term())

  @type cause ::
          :unspecified
          | :unhandled_command
          | :bad_schedule_activity_attributes
          | :bad_request_cancel_activity_attributes
          | :bad_start_timer_attributes
          | :bad_cancel_timer_attributes
          | :bad_record_marker_attributes
          | :bad_complete_workflow_execution_attributes
          | :bad_fail_workflow_execution_attributes
          | :bad_cancel_workflow_execution_attributes
          | :bad_request_cancel_external_workflow_execution_attributes
          | :bad_continue_as_new_attributes
          | :start_timer_duplicate_id
          | :reset_sticky_task_queue
          | :workflow_worker_unhandled_failure
          | :bad_signal_workflow_execution_attributes
          | :bad_start_child_execution_attributes
          | :force_close_command
          | :failover_close_command
          | :bad_signal_input_size
          | :reset_workflow
          | :bad_binary
          | :schedule_activity_duplicate_id
          | :bad_search_attributes
          | :non_deterministic_error
          | :bad_modify_workflow_properties_attributes
          | :pending_child_workflows_limits_exceeded
          | :pending_activities_limit_exceeded
          | :pending_signals_limit_exceeded
          | :pending_request_cancel_limit_exceeded
          | :bad_update_workflow_execution_message
          | :unhandled_update
          | :bad_schedule_nexus_operation_attributes
          | :pending_nexus_operations_limit_exceeded
          | :bad_request_cancel_nexus_operation_attributes
          | :feature_disabled
          | :grpc_message_too_large
          | :payloads_too_large
end
