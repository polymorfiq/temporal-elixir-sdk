defmodule Temporal.CoreSdk.Data.WorkflowCommandContinueAsNewWorkflowExecution do
  defstruct [
    :workflow_type,
    :task_queue,
    :arguments,
    :memo,
    :headers,
    :versioning_intent,
    :initial_versioning_behavior,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    search_attributes: nil,
    retry_policy: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          workflow_type: String.t(),
          task_queue: String.t(),
          arguments: [Data.ActivationPayload.t()],
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          memo: map(),
          headers: map(),
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          retry_policy: Data.WorkflowRetryPolicy.t() | nil,
          versioning_intent: integer(),
          initial_versioning_behavior: integer()
        }
end
