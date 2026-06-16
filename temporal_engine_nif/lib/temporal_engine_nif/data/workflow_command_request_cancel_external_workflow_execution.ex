defmodule TemporalEngineNif.Data.WorkflowCommandRequestCancelExternalWorkflowExecution do
  defstruct [:seq, :reason, workflow_execution: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          workflow_execution: Data.WorkflowNamespacedExecution.t() | nil,
          reason: String.t()
        }
end
