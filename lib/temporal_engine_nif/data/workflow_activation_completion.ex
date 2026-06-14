defmodule TemporalEngineNif.Data.WorkflowActivationCompletion do
  defstruct [:run_id, :status]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          run_id: String.t(),
          status:
            {:successful, Data.WorkflowActivationCompletionSuccessStatus.t()}
            | {:failed, Data.WorkflowActivationCompletionFailureStatus.t()}
        }
end
