defmodule TemporalEngineNif.Data.WorkflowNexusHandlerFailureInfo do
  defstruct [
    :failure_type,
    retry_behavior: :unspecified
  ]

  @type retry_behavior :: :unspecified | :retryable | :non_retryable
  @type t :: %__MODULE__{failure_type: String.t(), retry_behavior: retry_behavior()}
end
