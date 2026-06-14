defmodule TemporalEngineNif.Data.WorkflowResetFailureInfo do
  defstruct last_heartbeat_details: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          last_heartbeat_details: Data.Payload.t() | nil
        }
end
