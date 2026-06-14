defmodule TemporalEngineNif.Data.WorkflowNexusOperationStartStatus do
  defstruct operation_token: nil, started_sync: nil, failed: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          operation_token: String.t() | nil,
          started_sync: bool() | nil,
          failed: Data.WorkflowFailure.t() | nil
        }
end
