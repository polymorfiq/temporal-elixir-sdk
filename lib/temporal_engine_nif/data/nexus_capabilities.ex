defmodule TemporalEngineNif.Data.NexusCapabilities do
  defstruct [:temporal_failure_responses]

  @type t :: %__MODULE__{
          temporal_failure_responses: bool()
        }
end
