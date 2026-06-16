defmodule TemporalEngineNif.Data.ActivationResolveSignalExternalWorkflow do
  defstruct [:seq, failure: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          failure: Data.WorkflowFailure.t()
        }
end
