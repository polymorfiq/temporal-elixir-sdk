defmodule TemporalEngineNif.Data.WorkflowType do
  defstruct [
    :name
  ]

  @type t :: %__MODULE__{name: String.t()}
end
