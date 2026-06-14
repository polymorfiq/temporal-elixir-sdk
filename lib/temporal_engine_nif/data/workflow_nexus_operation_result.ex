defmodule TemporalEngineNif.Data.WorkflowNexusOperationResult do
  defstruct status: nil

  @type t :: %__MODULE__{
          status: WorkflowNexusOperationStatus.t() | nil
        }
end
