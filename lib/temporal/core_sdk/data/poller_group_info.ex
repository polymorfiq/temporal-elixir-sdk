defmodule Temporal.CoreSdk.Data.PollerGroupInfo do
  defstruct [:id, :weight]

  @type t :: %__MODULE__{
          id: String.t(),
          weight: float()
        }
end
