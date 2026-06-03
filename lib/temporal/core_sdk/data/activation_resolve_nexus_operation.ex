defmodule Temporal.CoreSdk.Data.ActivationResolveNexusOperation do
  defstruct [:seq, status: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          status: Data.WorkflowResolveNexusOperationStatus.t() | nil
        }
end
