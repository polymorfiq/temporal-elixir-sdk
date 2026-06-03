defmodule Temporal.CoreSdk.Data.ActivityTaskStart do
  defstruct [
    :workflow_namespace,
    :workflow_type,
    :activity_id,
    :activity_type,
    :header_fields,
    :input,
    :heartbeat_details,
    :attempt,
    :is_local,
    :run_id,
    workflow_execution: nil,
    scheduled_time: nil,
    current_attempt_scheduled_time: nil,
    started_time: nil,
    schedule_to_close_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          workflow_namespace: String.t(),
          workflow_type: String.t(),
          workflow_execution: Data.WorkflowExecution.t() | nil,
          activity_id: String.t(),
          activity_type: String.t(),
          header_fields: map(),
          input: [Data.ActivationPayload.t()],
          heartbeat_details: [Data.ActivationPayload.t()],
          scheduled_time: Data.Timestamp.t() | nil,
          current_attempt_scheduled_time: Data.Timestamp.t() | nil,
          started_time: Data.Timestamp.t() | nil,
          attempt: pos_integer(),
          schedule_to_close_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          heartbeat_timeout: Data.Duration.t() | nil,
          retry_policy: Data.WorkflowRetryPolicy.t() | nil,
          priority: Data.WorkflowPriority.t(),
          is_local: bool(),
          run_id: String.t()
        }
end
