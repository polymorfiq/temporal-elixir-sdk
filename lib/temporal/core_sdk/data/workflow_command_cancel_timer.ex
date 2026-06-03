defmodule Temporal.CoreSdk.Data.WorkflowCommandCancelTimer do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }
end
