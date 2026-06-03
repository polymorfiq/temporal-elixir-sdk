defmodule Temporal.CoreSdk.Data.WorkflowNexusHandlerFailureInfo do
  defstruct [
    :failure_type,
    :retry_behavior
  ]

  @type t :: %__MODULE__{failure_type: String.t(), retry_behavior: integer()}
end
