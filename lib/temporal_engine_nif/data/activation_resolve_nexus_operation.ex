defmodule TemporalEngineNif.Data.ActivationResolveNexusOperation do
  defstruct [:seq, status: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowResolveNexusOperationStatus.t() | nil
        }
end
