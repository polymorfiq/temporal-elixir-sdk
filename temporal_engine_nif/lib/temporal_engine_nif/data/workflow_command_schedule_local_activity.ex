defmodule TemporalEngineNif.Data.WorkflowCommandScheduleLocalActivity do
  defstruct [
    :seq,
    :activity_id,
    :activity_type,
    :attempt,
    :headers,
    :arguments,
    :cancellation_type,
    original_schedule_time: nil,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    retry_policy: nil,
    local_retry_threshold: nil
  ]

  alias TemporalEngineNif.Data

  @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          attempt: pos_integer(),
          original_schedule_time: Data.Timestamp.t() | nil,
          headers: %{String.t() => Data.Payload.t()},
          arguments: [Data.Payload.t()],
          schedule_to_close_timeout: Data.Duration.t() | nil,
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          local_retry_threshold: Data.Duration.t() | nil,
          cancellation_type: cancellation_type()
        }
end
