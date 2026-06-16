defmodule TemporalEngine.Data.RetryPolicy do
  require Record
  alias TemporalEngine.Data.Duration

  Record.defrecord(:policy, [
    :backoff_coefficient,
    :maximum_attempts,
    :non_retryable_error_types,
    initial_interval: nil,
    maximum_interval: nil
  ])

  @type policy ::
          record(:policy,
            initial_interval: Duration.t() | nil,
            backoff_coefficient: float(),
            maximum_interval: Duration.t() | nil,
            maximum_attempts: integer(),
            non_retryable_error_types: [String.t()]
          )
end
