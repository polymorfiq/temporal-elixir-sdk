defmodule Temporal.CoreSdk.Data.ActivationInitializeWorkflow do
  defstruct [
    :workflow_type,
    :workflow_id,
    :arguments,
    :randomness_seed,
    :headers,
    :identity,
    :continued_from_execution_run_id,
    :continued_initiator,
    :first_execution_run_id,
    :attempt,
    :cron_schedule,
    parent_workflow_info: nil,
    workflow_execution_timeout: nil,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    continued_failure: nil,
    last_completion_result: nil,
    retry_policy: nil,
    workflow_execution_expiration_time: nil,
    cron_schedule_to_schedule_interval: nil,
    memo: nil,
    search_attributes: nil,
    start_time: nil,
    root_workflow: nil,
    priority: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          workflow_type: String.t(),
          workflow_id: String.t(),
          arguments: Data.ActivationPayload.t(),
          randomness_seed: pos_integer(),
          headers: map(),
          identity: String.t(),
          parent_workflow_info: Data.WorkflowNamespacedExecution.t() | nil,
          workflow_execution_timeout: Data.Duration.t() | nil,
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          continued_from_execution_run_id: String.t(),
          continued_initiator: integer(),
          continued_failure: Data.WorkflowFailure.t() | nil,
          last_completion_result: Data.ActivationPayloads.t() | nil,
          first_execution_run_id: String.t(),
          retry_policy: Data.WorkflowRetryPolicy.t() | nil,
          attempt: integer(),
          cron_schedule: String.t(),
          workflow_execution_expiration_time: Data.Timestamp.t() | nil,
          cron_schedule_to_schedule_interval: Data.Duration.t() | nil,
          memo: Data.WorkflowMemo.t() | nil,
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          start_time: Data.Timestamp.t() | nil,
          root_workflow: Data.WorkflowExecution.t() | nil,
          priority: Data.WorkflowPriority.t() | nil
        }
end
