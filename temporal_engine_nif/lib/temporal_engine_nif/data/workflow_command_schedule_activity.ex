defmodule TemporalEngineNif.Data.WorkflowCommandScheduleActivity do
  defstruct [
    :seq,
    :activity_id,
    :activity_type,
    :task_queue,
    arguments: [],
    cancellation_type: :try_cancel,
    do_not_eagerly_execute: false,
    headers: %{},
    versioning_intent: :unspecified,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ]

  alias TemporalEngineNif.Data

  @type cancellation_type() :: :try_cancel | :wait_cancellation_completed | :abandon
  @type versioning_intent() :: :unspecified | :compatible | :default
  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          task_queue: String.t(),
          headers: %{String.t() => Data.Payload.t()},
          arguments: [Data.Payload.t()],
          schedule_to_close_timeout: Data.Duration.t() | nil,
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          heartbeat_timeout: Data.Duration.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          cancellation_type: cancellation_type(),
          do_not_eagerly_execute: bool(),
          versioning_intent: versioning_intent(),
          priority: Data.Priority.t() | nil
        }
end
