defmodule Temporal.CoreSdk.Data.WorkflowCommandStartChildWorkflowExecution do
  defstruct [
    :seq,
    :namespace,
    :workflow_id,
    :workflow_type,
    :task_queue,
    :input,
    :parent_close_policy,
    :workflow_id_reuse_policy,
    :cron_schedule,
    :headers,
    :memo,
    :cancellation_type,
    :versioning_intent,
    workflow_execution_timeout: nil,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    retry_policy: nil,
    search_attributes: nil,
    priority: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          namespace: String.t(),
          workflow_id: String.t(),
          workflow_type: String.t(),
          task_queue: String.t(),
          input: [Data.ActivationPayload.t()],
          workflow_execution_timeout: Data.Duration.t() | nil,
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          parent_close_policy: integer(),
          workflow_id_reuse_policy: integer(),
          retry_policy: Data.RetryPolicy.t() | nil,
          cron_schedule: String.t(),
          headers: map(),
          memo: map(),
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          cancellation_type: integer(),
          versioning_intent: integer(),
          priority: Data.Priority.t() | nil
        }
end
