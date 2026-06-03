defmodule Temporal.CoreSdk.Data.ActivationCancelWorkflow do
  defstruct [:reason]

  @type t :: %__MODULE__{
          reason: String.t()
        }
end
