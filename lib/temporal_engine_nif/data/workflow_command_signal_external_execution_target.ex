defmodule TemporalEngineNif.Data.WorkflowCommandSignalExternalExecutionTarget do
  defstruct workflow_execution: nil, child_workflow_id: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          workflow_execution: Data.WorkflowNamespacedExecution.t() | nil,
          child_workflow_id: String.t() | nil
        }
end
