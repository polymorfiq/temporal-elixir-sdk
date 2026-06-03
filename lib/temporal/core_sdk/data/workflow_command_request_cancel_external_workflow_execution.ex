defmodule Temporal.CoreSdk.Data.WorkflowCommandRequestCancelExternalWorkflowExecution do
  defstruct [:seq, :reason, workflow_execution: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          workflow_execution: Data.WorkflowNamespacedExecution.t() | nil,
          reason: String.t()
        }
end
