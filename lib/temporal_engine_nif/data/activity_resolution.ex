defmodule TemporalEngineNif.Data.ActivityResolution do
  defstruct status: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{status: Data.ActivityResolutionStatus.t() | nil}
end
