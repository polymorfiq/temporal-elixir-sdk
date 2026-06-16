defmodule TemporalEngineNif.Data.WorkflowActivationCompletionStatus do
  defstruct [
    :run_id,
    status: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          run_id: String.t(),
          status: Data.WorkflowActivationCompletionStatus.t() | nil
        }
end
