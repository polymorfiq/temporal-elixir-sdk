defmodule Temporal.CoreSdk.Data.ActivationResolveChildWorkflowExecution do
  defstruct [:seq, status: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowChildExecutionStatus.t()
        }
end
