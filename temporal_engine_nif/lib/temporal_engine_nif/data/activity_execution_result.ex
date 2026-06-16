defmodule TemporalEngineNif.Data.ActivityExecutionResult do
  defstruct status: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          status: Data.ActivityExecutionStatus.t() | nil
        }
end
