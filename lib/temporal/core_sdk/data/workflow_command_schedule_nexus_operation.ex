defmodule Temporal.CoreSdk.Data.WorkflowCommandScheduleNexusOperation do
  defstruct [
    :seq,
    :endpoint,
    :service,
    :operation,
    :nexus_header,
    :cancellation_type,
    input: nil,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          endpoint: String.t(),
          service: String.t(),
          operation: String.t(),
          input: Data.ActivationPayload.t() | nil,
          schedule_to_close_timeout: Data.Duration.t() | nil,
          nexus_header: map(),
          cancellation_type: integer(),
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil
        }
end
