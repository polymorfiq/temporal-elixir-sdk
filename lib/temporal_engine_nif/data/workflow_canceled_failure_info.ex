defmodule TemporalEngineNif.Data.WorkflowCanceledFailureInfo do
  defstruct [
    :identity,
    details: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          identity: String.t(),
          details: Data.Payload.t() | nil
        }
end
