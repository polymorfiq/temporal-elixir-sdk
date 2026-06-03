defmodule Temporal.CoreSdk.Data.WorkflowCommandCancelSignalWorkflow do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }
end
