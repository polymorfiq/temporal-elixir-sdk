defmodule TemporalEngineNif.Data.UserMetadata do
  defstruct summary: nil,
            details: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          summary: Data.Payload.t() | nil,
          details: Data.Payload.t() | nil
        }
end
