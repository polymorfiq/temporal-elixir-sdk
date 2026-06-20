defmodule TemporalEngine.Data.RetryPolicy do
  use TemporalEngine.Data.TypeSpec
  alias TemporalEngine.Data.Duration

  deftype :policy do
    @structdoc "How retries ought to be handled, usable by both workflows and activities"

    @doc "Interval of the first retry. If `backoff_coefficient` is 1.0 then it is used for all retries."
    @type initial_interval :: nested!(Duration.duration())

    @doc "Coefficient used to calculate the next retry interval. The next retry interval is previous interval multiplied by the coefficient. Must be 1 or larger."
    @default 1.7
    @type backoff_coefficient :: required :: float()

    @doc "Maximum interval between retries. Exponential backoff leads to interval increase. This value is the cap of the increase. Default is 100x of the initial interval."
    @type maximum_interval :: nested!(Duration.duration())

    @doc "Maximum number of attempts. When exceeded the retries stop even if not expired yet. 1 disables retries. 0 means unlimited (up to the timeouts)"
    @type maximum_attempts :: required :: integer()

    @doc "Non-Retryable errors types. Will stop retrying if the error type matches this list. Note that this is not a substring match, the error type (not message) must match exactly."
    @default []
    @type non_retryable_error_types :: required :: [String.t()]
  end
end
