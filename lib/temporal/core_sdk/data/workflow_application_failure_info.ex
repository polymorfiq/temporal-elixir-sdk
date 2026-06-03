defmodule Temporal.CoreSdk.Data.WorkflowApplicationFailureInfo do
  defstruct [
    :failure_type,
    :non_retryable,
    :category,
    details: nil,
    next_retry_delay: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure_type: String.t(),
          non_retryable: bool(),
          details: Data.ActivationPayloads.t() | nil,
          next_retry_delay: Data.Duration.t() | nil,
          category: integer()
        }
end
