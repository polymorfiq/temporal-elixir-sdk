defmodule TemporalEngineNif.Data.ActivityCancellationDetails do
  defstruct [
    :is_not_found,
    :is_cancelled,
    :is_paused,
    :is_timed_out,
    :is_worker_shutdown,
    :is_reset
  ]

  @type t :: %__MODULE__{
          is_not_found: bool(),
          is_cancelled: bool(),
          is_paused: bool(),
          is_timed_out: bool(),
          is_worker_shutdown: bool(),
          is_reset: bool()
        }
end
