defmodule Temporal.CoreSdk.Data.WorkflowNexusOperationStatus do
  defstruct completed: nil, failed: nil, cancelled: nil, timed_out: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          completed: Data.Payload.t() | nil,
          failed: Data.WorkflowFailure.t() | nil,
          cancelled: Data.WorkflowFailure.t() | nil,
          timed_out: Data.WorkflowFailure.t() | nil
        }
end
