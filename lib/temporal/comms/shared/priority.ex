defmodule Temporal.Comms.Shared.Priority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  @type t :: %__MODULE__{
          priority_key: integer(),
          fairness_key: String.t(),
          fairness_weight: float()
        }

  @type priority :: [
          {:priority_key, integer()} | {:fairness_key, String.t()} | {:fairness_weight, float()}
        ]

  @spec send_to_engine(priority()) :: t()
  def send_to_engine(opts), do: struct!(__MODULE__, opts)

  @spec send_to_sdk(t()) :: priority()
  def send_to_sdk(priority), do: priority |> Map.from_struct() |> Keyword.new()
end
