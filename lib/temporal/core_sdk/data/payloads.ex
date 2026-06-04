defmodule Temporal.CoreSdk.Data.Payloads do
  defstruct [
    :payloads
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          payloads: [Data.ActivationPayload.t()]
        }
end
