defmodule TemporalEngineNif.Data.ActivationResolveNexusOperationStart do
  defstruct [:seq, status: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowResolveNexusOperationStartStatus.t() | nil
        }
end
