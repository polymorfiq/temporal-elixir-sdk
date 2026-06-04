defmodule Temporal.CoreSdk.Data.RetryPolicy do
  defstruct [
    :backoff_coefficient,
    :maximum_attempts,
    :non_retryable_error_types,
    initial_interval: nil,
    maximum_interval: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          initial_interval: Data.Duration.t() | nil,
          backoff_coefficient: float(),
          maximum_interval: Data.Duration.t() | nil,
          maximum_attempts: integer(),
          non_retryable_error_types: [String.t()]
        }
end
