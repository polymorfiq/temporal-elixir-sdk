defmodule Temporal.CoreSdk.Data.Timestamp do
  defstruct [
    :seconds,
    :nanos
  ]

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}
  @type opts :: DateTime.t()

  @spec with_opts!(opts()) :: t()
  def with_opts!(%DateTime{} = dt) do
    %__MODULE__{
      seconds: DateTime.to_unix(dt, :second),
      nanos: rem(DateTime.to_unix(dt, :nanosecond), 1_000_000_000)
    }
  end
end
