defmodule TemporalEngineNif.Data.Timestamp do
  defstruct [
    :seconds,
    :nanos
  ]

  require TemporalEngine.Data.Timestamp

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}

  def to_record(%__MODULE__{seconds: seconds, nanos: nanos}) do
    TemporalEngine.Data.Timestamp.timestamp(seconds: seconds, nanos: nanos)
  end
end
