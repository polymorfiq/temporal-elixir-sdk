defmodule Temporal.CoreSdk.Data.WorkflowGetResultOptions do
  defstruct [:follow_runs]

  @type t :: %__MODULE__{
          follow_runs: bool()
        }
end
