defmodule Temporal.CoreSdk.Data.WorkflowPriority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  @type t :: %__MODULE__{
          priority_key: integer(),
          fairness_key: String.t(),
          fairness_weight: float()
        }
end
