defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletion do
  defstruct successful: nil,
            failed: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          successful: Data.WorkflowActivationCompletionSuccessStatus.t() | nil,
          failed: Data.WorkflowActivationCompletionFailureStatus.t() | nil
        }
end
