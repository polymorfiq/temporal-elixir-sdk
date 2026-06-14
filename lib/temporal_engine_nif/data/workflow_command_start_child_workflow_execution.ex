defmodule TemporalEngineNif.Data.WorkflowCommandStartChildWorkflowExecution do
  defstruct [
    :seq,
    :namespace,
    :workflow_id,
    :workflow_type,
    :task_queue,
    :input,
    :cron_schedule,
    :cancellation_type,
    headers: %{},
    memo: %{},
    workflow_id_reuse_policy: :unspecified,
    parent_close_policy: :unspecified,
    versioning_intent: :unspecified,
    workflow_execution_timeout: nil,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    retry_policy: nil,
    search_attributes: nil,
    priority: nil
  ]

  alias TemporalEngineNif.Data

  @type workflow_id_reuse_policy ::
          :unspecified
          | :allow_duplicate
          | :allow_duplicate_failed_only
          | :reject_duplicate
          | :terminate_if_running
  @type parent_close_policy :: :unspecified | :terminate | :abandon | :request_cancel
  @type versioning_intent :: :unspecified | :compatible | :default
  @type cancellation_type ::
          :abandon | :try_cancel | :wait_cancellation_completed | :wait_cancellation_requested

  @type t :: %__MODULE__{
          seq: pos_integer(),
          namespace: String.t(),
          workflow_id: String.t(),
          workflow_type: String.t(),
          task_queue: String.t(),
          input: [Data.Payload.t()],
          workflow_execution_timeout: Data.Duration.t() | nil,
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          parent_close_policy: parent_close_policy(),
          workflow_id_reuse_policy: workflow_id_reuse_policy(),
          retry_policy: Data.RetryPolicy.t() | nil,
          cron_schedule: String.t(),
          headers: %{String.t() => Data.Payload.t()},
          memo: %{String.t() => Data.Payload.t()},
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          cancellation_type: cancellation_type(),
          versioning_intent: versioning_intent(),
          priority: Data.Priority.t() | nil
        }
end
