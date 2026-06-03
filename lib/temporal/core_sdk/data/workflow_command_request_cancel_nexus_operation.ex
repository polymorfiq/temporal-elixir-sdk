defmodule Temporal.CoreSdk.Data.WorkflowCommandRequestCancelNexusOperation do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }
end
