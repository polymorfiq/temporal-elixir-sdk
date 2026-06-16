defmodule TemporalEngine.Data.Timestamp do
  require Record

  Record.defrecord(:timestamp, [:seconds, :nanos])
  @type t :: record(:timestamp, seconds: integer(), nanos: integer())

  def to_native(timestamp(seconds: seconds, nanos: nanos)),
    do: DateTime.from_unix!(seconds) |> DateTime.add(nanos, :nanosecond)
end
