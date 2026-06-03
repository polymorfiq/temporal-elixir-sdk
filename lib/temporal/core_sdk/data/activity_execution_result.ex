defmodule Temporal.CoreSdk.Data.ActivityExecutionResult do
  defstruct status: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          status: Data.ActivityExecutionStatus.t() | nil
        }
end
