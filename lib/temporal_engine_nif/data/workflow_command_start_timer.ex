defmodule TemporalEngineNif.Data.WorkflowCommandStartTimer do
  defstruct [:seq, start_to_fire_timeout: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          start_to_fire_timeout: Data.Duration.t() | nil
        }
end
