defmodule TemporalEngineNif.Data.WorkflowChildExecutionStartStatus do
  defstruct succeeded: nil, failed: nil, cancelled: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          succeeded: Data.WorkflowChildExecutionStartSucceededStatus.t() | nil,
          failed: Data.WorkflowChildExecutionStartFailedStatus.t() | nil,
          cancelled: Data.WorkflowChildExecutionStartCancelledStatus.t() | nil
        }
end
