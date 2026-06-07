defmodule Temporal.CoreSdk.Data.WorkflowChildExecutionCompletedStatus do
  defstruct result: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          result: Data.Payload.t() | nil
        }
end
