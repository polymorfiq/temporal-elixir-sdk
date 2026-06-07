defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus do
  defstruct force_cause: :unspecified, failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil,
          force_cause: cause()
        }

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

  @type opts :: [{:failure, Data.WorkflowFailure.opts()}, {:force_cause, cause()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    status = struct!(__MODULE__, opts)

    status =
      if opts[:failure] do
        update_in(status, [Access.key(:failure)], &Data.WorkflowFailure.with_opts!/1)
      else
        status
      end

    status
  end
end
