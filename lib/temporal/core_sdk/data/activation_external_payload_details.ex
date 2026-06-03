defmodule Temporal.CoreSdk.Data.ActivationExternalPayloadDetails do
  defstruct [:size_bytes]

  @type t :: %__MODULE__{size_bytes: integer()}
end
