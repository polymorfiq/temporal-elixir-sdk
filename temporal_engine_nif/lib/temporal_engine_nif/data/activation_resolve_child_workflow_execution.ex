defmodule TemporalEngineNif.Data.ActivationResolveChildWorkflowExecution do
  defstruct [:seq, status: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowChildExecutionStatus.t()
        }
end
