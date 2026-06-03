defmodule Temporal.CoreSdk.Data.UserMetadata do
  defstruct summary: nil,
            details: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          summary: Data.ActivationPayload.t() | nil,
          details: Data.ActivationPayload.t() | nil
        }
end
