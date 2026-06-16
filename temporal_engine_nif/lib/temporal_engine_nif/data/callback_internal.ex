defmodule TemporalEngineNif.Data.CallbackInternal do
  defstruct [:data]

  @type t :: %__MODULE__{
          data: [byte()]
        }
end
