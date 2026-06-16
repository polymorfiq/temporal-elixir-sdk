defmodule TemporalEngineNif.Data.WorkflowServerFailureInfo do
  defstruct [:non_retryable]

  @type t :: %__MODULE__{
          non_retryable: bool()
        }
end
