defmodule TemporalEngineNif.Data.WorkflowExecution do
  defstruct [:workflow_id, :run_id]

  @type t :: %__MODULE__{
          workflow_id: String.t(),
          run_id: String.t()
        }
end
