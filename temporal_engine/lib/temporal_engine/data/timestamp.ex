defmodule TemporalEngine.Data.Timestamp do
  use TemporalEngine.Data.TypeSpec

  deftype :timestamp do
    @type seconds :: required :: integer()
    @type nanos :: required :: integer()
  end

  @type shorthand :: DateTime.t()

  def to_native(timestamp(seconds: seconds, nanos: nanos)),
    do: DateTime.from_unix!(seconds) |> DateTime.add(nanos, :nanosecond)
end
