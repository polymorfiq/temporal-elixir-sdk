defmodule TemporalEngine.Data.Timestamp do
  require Record

  Record.defrecord(:timestamp, [:seconds, :nanos])
  @type t :: record(:timestamp, seconds: integer(), nanos: integer())
end
