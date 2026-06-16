defmodule TemporalEngineNif.Data.WorkflowChildExecutionStartFailedStatus do
  defstruct [:workflow_id, :workflow_type, cause: :unspecified]

  @type cause :: :unspecified | :workflow_already_exists
  @type t :: %__MODULE__{workflow_id: String.t(), workflow_type: String.t(), cause: cause()}
end
