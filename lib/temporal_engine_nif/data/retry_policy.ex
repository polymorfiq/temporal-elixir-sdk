defmodule TemporalEngineNif.Data.RetryPolicy do
  defstruct [
    :backoff_coefficient,
    :maximum_attempts,
    :non_retryable_error_types,
    initial_interval: nil,
    maximum_interval: nil
  ]

  import TemporalEngine.Data.RetryPolicy

  alias TemporalEngineNif.Data.Duration
  alias TemporalEngine.Data.RetryPolicy, as: EnginePolicy

  @type t :: %__MODULE__{
          initial_interval: Duration.t() | nil,
          backoff_coefficient: float(),
          maximum_interval: Duration.t() | nil,
          maximum_attempts: integer(),
          non_retryable_error_types: [String.t()]
        }

  @spec to_record(t() | nil) :: EnginePolicy.policy() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{} = policy) do
    policy(
      initial_interval: Duration.to_record(policy.initial_interval),
      backoff_coefficient: policy.backoff_coefficient,
      maximum_interval: Duration.to_record(policy.maximum_interval),
      maximum_attempts: policy.maximum_attempts,
      non_retryable_error_types: policy.non_retryable_error_types
    )
  end
end
