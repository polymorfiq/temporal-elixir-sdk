defmodule TemporalEngineNif.Data.WorkflowCommandQuerySuccess do
  defstruct response: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          response: Data.Payload.t() | nil
        }
end
