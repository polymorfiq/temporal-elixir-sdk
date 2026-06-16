defmodule TemporalEngineNif.Data.WorkflowCommandRequestCancelLocalActivity do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }
end
