defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus do
  defstruct [:force_cause, failure: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil,
          force_cause: integer()
        }
end
