defmodule TemporalEngineNif.Data.ActivityResolutionCompletedStatus do
  defstruct result: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          result: Data.Payload.t() | nil
        }
end
