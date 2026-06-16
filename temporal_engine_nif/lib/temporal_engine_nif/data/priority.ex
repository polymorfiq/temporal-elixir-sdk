defmodule TemporalEngineNif.Data.Priority do
  defstruct [:priority_key, :fairness_key, :fairness_weight]

  import TemporalEngine.Data.Priority

  alias TemporalEngine.Data.Priority, as: EnginePriority

  @type t :: %__MODULE__{
          priority_key: integer(),
          fairness_key: String.t(),
          fairness_weight: float()
        }

  @spec to_record(t() | nil) :: EnginePriority.priority() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{} = priority) do
    priority(
      priority_key: priority.priority_key,
      fairness_key: priority.fairness_key,
      fairness_weight: priority.fairness_weight
    )
  end

  @spec from_record(EnginePriority.priority() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(priority() = p) do
    %__MODULE__{
      priority_key: priority(p, :priority_key),
      fairness_key: priority(p, :fairness_key),
      fairness_weight: priority(p, :fairness_weight)
    }
  end
end
