defmodule Temporal.CoreSdk.Data.WorkflowCanceledFailureInfo do
  defstruct [
    :identity,
    details: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          identity: String.t(),
          details: Data.ActivationPayloads.t() | nil
        }
end
