defmodule TemporalEngineNif.Data.ActivationResolveChildWorkflowExecutionStart do
  defstruct [:seq, status: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowChildExecutionStartStatus.t()
        }
end
