defmodule TemporalEngineNif.Data.WorkflowChildExecutionStatus do
  defstruct completed: nil, failed: nil, cancelled: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          completed: Data.WorkflowChildExecutionCompletedStatus.t() | nil,
          failed: Data.WorkflowChildExecutionFailedStatus.t() | nil,
          cancelled: Data.WorkflowChildExecutionCancelledStatus.t() | nil
        }
end
