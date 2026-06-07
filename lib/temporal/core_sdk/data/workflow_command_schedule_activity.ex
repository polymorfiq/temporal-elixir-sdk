defmodule Temporal.CoreSdk.Data.WorkflowCommandScheduleActivity do
  defstruct [
    :seq,
    :activity_id,
    :activity_type,
    :task_queue,
    :headers,
    :arguments,
    :cancellation_type,
    :do_not_eagerly_execute,
    :versioning_intent,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          task_queue: String.t(),
          headers: map(),
          arguments: [Data.Payload.t()],
          schedule_to_close_timeout: Data.Duration.t() | nil,
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          heartbeat_timeout: Data.Duration.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          cancellation_type: integer(),
          do_not_eagerly_execute: bool(),
          versioning_intent: integer(),
          priority: Data.Priority.t() | nil
        }
end
