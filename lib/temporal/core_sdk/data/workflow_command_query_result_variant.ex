defmodule Temporal.CoreSdk.Data.WorkflowCommandQueryResultVariant do
  defstruct succeeded: nil, failed: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          succeeded: Data.WorkflowCommandQuerySuccess.t() | nil,
          failed: Data.WorkflowFailure.t() | nil
        }
end
