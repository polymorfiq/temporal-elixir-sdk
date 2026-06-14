defmodule TemporalEngineNif.Data.WorkflowCommandScheduleNexusOperation do
  defstruct [
    :seq,
    :endpoint,
    :service,
    :operation,
    :cancellation_type,
    nexus_header: %{},
    input: nil,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil
  ]

  alias TemporalEngineNif.Data

  @type cancellation_type ::
          :wait_cancellation_completed | :abandon | :try_cancel | :wait_cancellation_requested

  @type t :: %__MODULE__{
          seq: pos_integer(),
          endpoint: String.t(),
          service: String.t(),
          operation: String.t(),
          input: Data.Payload.t() | nil,
          schedule_to_close_timeout: Data.Duration.t() | nil,
          nexus_header: %{String.t() => String.t()},
          cancellation_type: cancellation_type(),
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil
        }
end
