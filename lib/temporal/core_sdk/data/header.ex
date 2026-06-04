defmodule Temporal.CoreSdk.Data.Header do
  defstruct [
    :fields
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.ActivationPayload.t()}
        }
end
