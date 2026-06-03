defmodule Temporal.CoreSdk.Data.ActivationNotifyHasPatch do
  defstruct [:patch_id]

  @type t :: %__MODULE__{
          patch_id: String.t()
        }
end
