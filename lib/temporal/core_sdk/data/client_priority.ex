defmodule Temporal.CoreSdk.Data.ClientPriority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  @type t :: %__MODULE__{
               priority_key: pos_integer() | nil,
               fairness_key: String.t() | nil,
               fairness_weight: float() | nil
             }
end
