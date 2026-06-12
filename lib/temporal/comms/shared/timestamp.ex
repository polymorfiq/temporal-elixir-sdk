defmodule Temporal.Comms.Shared.Timestamp do
  defstruct [
    :seconds,
    :nanos
  ]

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}
  @type timestamp :: DateTime.t()

  @spec send_to_engine(timestamp()) :: t()
  def send_to_engine(%DateTime{} = dt) do
    %__MODULE__{
      seconds: DateTime.to_unix(dt, :second),
      nanos: rem(DateTime.to_unix(dt, :nanosecond), 1_000_000_000)
    }
  end

  @spec send_to_sdk(t()) :: timestamp()
  def send_to_sdk(%__MODULE__{} = ts) do
    nanoseconds = ts.seconds * 1_000_000_000 + ts.nanos
    DateTime.from_unix!(nanoseconds, :nanosecond)
  end
end
