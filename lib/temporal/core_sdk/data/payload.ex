defmodule Temporal.CoreSdk.Data.Payload do
  defstruct [
    :metadata,
    :data,
    :external_payloads
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          metadata: map(),
          data: [byte()],
          external_payloads: [Data.ActivationExternalPayloadDetails.t()]
        }
end
