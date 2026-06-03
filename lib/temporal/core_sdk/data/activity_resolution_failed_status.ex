defmodule Temporal.CoreSdk.Data.ActivityResolutionFailedStatus do
  defstruct failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }
end
