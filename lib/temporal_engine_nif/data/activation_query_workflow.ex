defmodule TemporalEngineNif.Data.ActivationQueryWorkflow do
  defstruct [:query_id, :query_type, :arguments, :headers]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          query_id: String.t(),
          query_type: String.t(),
          arguments: [Data.Payload.t()],
          headers: map()
        }
end
