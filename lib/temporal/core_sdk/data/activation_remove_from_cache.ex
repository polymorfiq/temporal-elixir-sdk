defmodule Temporal.CoreSdk.Data.ActivationRemoveFromCache do
  defstruct [:message, :reason]

  @type t :: %__MODULE__{
          message: String.t(),
          reason: integer()
        }
end
