defmodule Temporal.CoreSdk.Data.ActivationResolveNexusOperationStart do
  defstruct [:seq, status: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowResolveNexusOperationStartStatus.t() | nil
        }
end
