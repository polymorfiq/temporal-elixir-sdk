defmodule TemporalEngineNif.Data.ActivationResolveActivity do
  defstruct [:seq, :is_local, result: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          result: Data.ActivityResolution.t() | nil,
          is_local: bool()
        }
end
