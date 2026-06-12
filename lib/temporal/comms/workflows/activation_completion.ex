defmodule Temporal.Comms.Workflows.ActivationCompletion do
  defstruct [:run_id, :status]

  alias Temporal.Comms.Workflows.Command

  @type run_id() :: String.t()

  @type activation_completion ::
          {:activation_completion, run_id(),
           [Command.command()]
           | {:success, [Command.command()]}
           | {:success, [Command.command()], Success.opts()}
           | {:failure, Failure.cause(), message :: String.t()}
           | {:failure, Failure.cause(), message :: String.t(), Failure.opts()}}

  defmodule Success do
    defstruct [:commands, used_internal_flags: [], versioning_behavior: :unspecified]

    @type versioning_behavior :: :unspecified | :pinned | :auto_upgrade

    @type opts :: [
            {:used_internal_flags, [pos_integer()]}
            | {:versioning_behavior, versioning_behavior()}
          ]

    def send_to_engine({:success, cmds, opts}) do
      commands = Enum.map(cmds, &Command.send_to_engine/1)
      opts = Keyword.put(opts, :commands, commands)

      {:successful, struct!(__MODULE__, opts)}
    end
  end

  defmodule Failure do
    defstruct force_cause: :unspecified, failure: nil

    alias Temporal.Comms.Shared.Failure

    @type failure ::
            {:failure, message :: String.t()}
            | {:failure, cause(), message :: String.t()}
            | {:failure, cause(), message :: String.t(), Failure.opts()}

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

    def send_to_engine({:failure, cause, message, opts}) do
      {:failed,
       %__MODULE__{force_cause: cause, failure: Failure.send_to_engine({:failure, message, opts})}}
    end
  end

  def send_to_engine({:activation_completion, run_id, cmds}) when is_list(cmds),
    do: send_to_engine({:activation_completion, run_id, {:success, cmds}})

  def send_to_engine({:activation_completion, run_id, {:success, cmds}}),
    do: send_to_engine({:activation_completion, run_id, {:success, cmds, []}})

  def send_to_engine({:activation_completion, run_id, {:success, _, _} = success}) do
    %__MODULE__{run_id: run_id, status: Success.send_to_engine(success)}
  end

  def send_to_engine({:activation_completion, run_id, {:failure, message}}),
    do: send_to_engine({:activation_completion, run_id, {:failure, :unspecified, message, []}})

  def send_to_engine({:activation_completion, run_id, {:failure, cause, message}}),
    do: send_to_engine({:activation_completion, run_id, {:failure, cause, message, []}})

  def send_to_engine({:activation_completion, run_id, {:failure, _, _, _} = failure}) do
    %__MODULE__{run_id: run_id, status: Failure.send_to_engine(failure)}
  end
end
