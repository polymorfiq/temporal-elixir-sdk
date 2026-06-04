defmodule Temporal.CoreSdk.Data.CallbackNexus do
  defstruct [:url, :header]

  @type t :: %__MODULE__{
          url: String.t(),
          header: %{String.t() => String.t()}
        }
end
