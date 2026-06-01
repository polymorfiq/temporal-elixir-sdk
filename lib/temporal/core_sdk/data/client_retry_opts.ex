defmodule Temporal.CoreSdk.Data.ClientRetryOpts do
  defstruct [
    :initial_interval_secs,
    :randomization_factor,
    :multiplier,
    :max_interval_secs,
    :max_elapsed_time_secs,
    :max_retries
  ]

  @type t :: %__MODULE__{
          initial_interval_secs: float(),
          randomization_factor: float(),
          multiplier: float(),
          max_interval_secs: float(),
          max_elapsed_time_secs: float(),
          max_retries: pos_integer()
        }
end
