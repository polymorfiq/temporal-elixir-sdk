defmodule Temporal.CoreSdk.Data.WorkflowMemo do
  defstruct [:fields]

  @type t :: %__MODULE__{
          fields: map()
        }
end
