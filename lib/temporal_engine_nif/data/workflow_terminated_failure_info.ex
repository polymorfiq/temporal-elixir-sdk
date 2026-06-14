defmodule TemporalEngineNif.Data.WorkflowTerminatedFailureInfo do
  defstruct [
    :identity
  ]

  @type t :: %__MODULE__{
          identity: String.t()
        }
end
