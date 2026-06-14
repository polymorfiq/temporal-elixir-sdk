defmodule TemporalEngineNif.Data.ActivityResolutionBackoffStatus do
  defstruct [:attempt, backoff_duration: nil, original_schedule_time: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          attempt: pos_integer(),
          backoff_duration: Data.Duration.t() | nil,
          original_schedule_time: Data.Timestamp.t() | nil
        }
end
