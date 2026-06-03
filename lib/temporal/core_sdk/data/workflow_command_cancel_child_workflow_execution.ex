defmodule Temporal.CoreSdk.Data.WorkflowCommandCancelChildWorkflowExecution do
  defstruct [:child_workflow_seq, :reason]

  @type t :: %__MODULE__{
          child_workflow_seq: integer(),
          reason: String.t()
        }
end
