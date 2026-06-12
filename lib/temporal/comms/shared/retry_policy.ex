defmodule Temporal.Comms.Shared.RetryPolicy do
  defstruct [
    :backoff_coefficient,
    :maximum_attempts,
    :non_retryable_error_types,
    initial_interval: nil,
    maximum_interval: nil
  ]

  alias Temporal.Comms.Shared.Duration

  @type t :: %__MODULE__{
          initial_interval: Duration.t() | nil,
          backoff_coefficient: float(),
          maximum_interval: Duration.t() | nil,
          maximum_attempts: integer(),
          non_retryable_error_types: [String.t()]
        }

  @type retry_policy :: [
          {:initial_interval, Duration.duration()}
          | {:backoff_coefficient, float()}
          | {:maximum_interval, Duration.duration()}
          | {:maximum_attempts, integer()}
          | {:non_retryable_error_types, [String.t()]}
        ]

  @spec send_to_sdk(t()) :: retry_policy()
  def send_to_sdk(%__MODULE__{} = policy) do
    policy = Map.from_struct(policy)

    policy =
      if policy[:initial_interval] do
        update_in(policy, [:initial_interval], &Duration.send_to_sdk/1)
      else
        policy
      end

    policy =
      if policy[:maximum_interval] do
        update_in(policy, [:maximum_interval], &Duration.send_to_sdk/1)
      else
        policy
      end

    policy
  end

  @spec send_to_engine(retry_policy()) :: t()
  def send_to_engine(opts) do
    retry = struct!(__MODULE__, opts)

    retry =
      if opts[:maximum_interval] do
        update_in(retry, [Access.key(:maximum_interval)], &Duration.send_to_engine/1)
      else
        retry
      end

    retry =
      if opts[:maximum_interval] do
        update_in(retry, [Access.key(:maximum_interval)], &Duration.send_to_engine/1)
      else
        retry
      end

    retry
  end
end
