defmodule TemporalEngineNif.Data.ActivityExecutionCancellation do
  defstruct failure: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }
end
