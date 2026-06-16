defmodule TemporalEngineNif.Data.Timestamp do
  defstruct [
    :seconds,
    :nanos
  ]

  require TemporalEngine.Data.Timestamp

  alias TemporalEngine.Data.Timestamp, as: EngineTimestamp

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}

  @spec to_record(t() | nil) :: EngineTimestamp.timestamp() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{seconds: seconds, nanos: nanos}) do
    EngineTimestamp.timestamp(seconds: seconds, nanos: nanos)
  end

  @spec from_record(EngineTimestamp.timestamp() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(EngineTimestamp.timestamp(seconds: seconds, nanos: nanos)) do
    %__MODULE__{seconds: seconds, nanos: nanos}
  end
end
