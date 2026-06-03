defmodule Temporal.CoreSdk.Data.ActivityExecutionCancellation do
  defstruct failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }
end
