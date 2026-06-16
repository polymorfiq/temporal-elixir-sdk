defmodule TemporalEngineNif.Data.Payloads do
  defstruct [
    :payloads
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          payloads: [Data.Payload.t()]
        }
end
