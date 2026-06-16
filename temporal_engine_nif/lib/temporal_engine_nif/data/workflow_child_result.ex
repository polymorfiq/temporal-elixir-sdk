defmodule TemporalEngineNif.Data.WorkflowChildResult do
  defstruct status: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          status: Data.WorkflowChildExecutionStatus.t() | nil
        }
end
