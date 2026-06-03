defmodule Temporal.CoreSdk.Data.WorkflowChildExecutionStartFailedStatus do
  defstruct [:workflow_id, :workflow_type, :cause]

  @type t :: %__MODULE__{workflow_id: String.t(), workflow_type: String.t(), cause: integer()}
end
