defmodule Temporal.CoreSdk.Data.ClientPriority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  @type t :: %__MODULE__{
          priority_key: pos_integer() | nil,
          fairness_key: String.t() | nil,
          fairness_weight: float() | nil
        }

  @type opts :: [
          {:priority_key, pos_integer()}
          | {:fairness_key, String.t()}
          | {:fairness_weight, float()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
