defmodule TemporalEngineNif.Data.WorkflowChildExecutionStartSucceededStatus do
  defstruct [:run_id]

  @type t :: %__MODULE__{run_id: String.t()}
end
