defmodule Temporal.CoreSdk.Data.WorkflowChildExecutionCancelledStatus do
  defstruct failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }
end
