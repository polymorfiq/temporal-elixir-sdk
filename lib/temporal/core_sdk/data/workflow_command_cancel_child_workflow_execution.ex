defmodule Temporal.CoreSdk.Data.WorkflowCommandCancelChildWorkflowExecution do
  defstruct [:child_workflow_seq, :reason]

  @type t :: %__MODULE__{
          child_workflow_seq: integer(),
          reason: String.t()
        }

  @type opts :: [{:child_workflow_seq, integer()} | {:reason, String.t()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts), do: struct!(__MODULE__, opts)
end
