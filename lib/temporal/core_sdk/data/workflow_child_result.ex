defmodule Temporal.CoreSdk.Data.WorkflowChildResult do
  defstruct status: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          status: Data.WorkflowChildExecutionStatus.t() | nil
        }
end
