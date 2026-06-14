defmodule TemporalEngineNif.Data.WorkflowActivityType do
  defstruct [:name]

  @type t :: %__MODULE__{name: String.t()}
end
