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

  @type opts :: [
          {:initial_interval, Data.Duration.opts()}
          | {:backoff_coefficient, float()}
          | {:maximum_interval, Data.Duration.opts()}
          | {:maximum_attempts, integer()}
          | {:non_retryable_error_types[String.t()]}
        ]

  def with_opts!(opts) do
    retry = struct!(__MODULE__, opts)

    retry =
      if opts[:maximum_interval] do
        update_in(retry, [Access.key(:maximum_interval)], &Data.Duration.with_opts!/1)
      else
        retry
      end

    retry =
      if opts[:maximum_interval] do
        update_in(retry, [Access.key(:maximum_interval)], &Data.Duration.with_opts!/1)
      else
        retry
      end

    retry
  end
end
