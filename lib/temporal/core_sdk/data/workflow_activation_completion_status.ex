defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionStatus do
  defstruct [
    :run_id,
    status: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          run_id: String.t(),
          status: Data.WorkflowActivationCompletionStatus.t() | nil
        }
end
