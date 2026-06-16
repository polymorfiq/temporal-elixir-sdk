defmodule TemporalEngineNif.Data.WorkflowApplicationFailureInfo do
  defstruct [
    :failure_type,
    :non_retryable,
    category: :unspecified,
    details: [],
    next_retry_delay: nil
  ]

  alias TemporalEngineNif.Data

  @type category :: :unspecified | :benign
  @type t :: %__MODULE__{
          failure_type: String.t(),
          non_retryable: bool(),
          details: [Data.Payload.t()],
          next_retry_delay: Data.Duration.t() | nil,
          category: category()
        }
end
