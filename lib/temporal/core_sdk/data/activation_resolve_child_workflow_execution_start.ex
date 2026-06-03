defmodule Temporal.CoreSdk.Data.ActivationResolveChildWorkflowExecutionStart do
  defstruct [:seq, status: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowChildExecutionStartStatus.t()
        }
end
