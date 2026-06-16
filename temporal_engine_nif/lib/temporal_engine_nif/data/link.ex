defmodule TemporalEngineNif.Data.Link do
  defstruct [
    :fields
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.Payload.t()}
        }
end
