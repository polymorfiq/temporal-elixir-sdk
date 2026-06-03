defmodule Temporal.CoreSdk.Data.ActivationResolveSignalExternalWorkflow do
  defstruct [:seq, failure: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          failure: Data.WorkflowFailure.t()
        }
end
