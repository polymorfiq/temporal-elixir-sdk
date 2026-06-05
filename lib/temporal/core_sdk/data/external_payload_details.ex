defmodule Temporal.CoreSdk.Data.ExternalPayloadDetails do
  defstruct [:size_bytes]

  @type t :: %__MODULE__{size_bytes: integer()}

  @type opts :: [{:size_bytes, integer()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
