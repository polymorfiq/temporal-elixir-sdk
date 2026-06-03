defmodule Temporal.CoreSdk.Data.WorkflowSearchAttributes do
  defstruct [:indexed_fields]

  @type t :: %__MODULE__{
          indexed_fields: map()
        }
end
