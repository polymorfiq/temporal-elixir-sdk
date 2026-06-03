defmodule Temporal.CoreSdk.Data.WorkflowCommandRequestCancelActivity do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }
end
