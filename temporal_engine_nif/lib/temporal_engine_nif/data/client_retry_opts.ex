defmodule TemporalEngineNif.Data.ClientRetryOpts do
  defstruct [
    :initial_interval,
    :randomization_factor,
    :multiplier,
    :max_interval,
    :max_elapsed_time,
    :max_retries
  ]

  alias TemporalEngine.Data.Duration

  @type t :: %__MODULE__{
          initial_interval: Duration.t(),
          randomization_factor: float(),
          multiplier: float(),
          max_interval: Duration.t(),
          max_elapsed_time: Duration.t(),
          max_retries: pos_integer()
        }
end
