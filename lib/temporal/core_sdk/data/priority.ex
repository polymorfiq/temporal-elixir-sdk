defmodule Temporal.CoreSdk.Data.Priority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  @type t :: %__MODULE__{
          priority_key: integer(),
          fairness_key: String.t(),
          fairness_weight: float()
        }

  @type opts :: [
          {:priority_key, integer()} | {:fairness_key, String.t()} | {:fairness_weight, float()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts), do: struct!(__MODULE__, opts)
end
