defmodule TemporalEngineNif.Data.Duration do
  defstruct [
    :seconds,
    :nanos
  ]

  require TemporalEngine.Data.Duration

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}

  @spec to_record(t() | nil) :: TemporalEngine.Data.Duration.duration() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{seconds: seconds, nanos: nanos}) do
    TemporalEngine.Data.Duration.duration(seconds: seconds, nanos: nanos)
  end

  @spec from_record(TemporalEngine.Data.Duration.duration() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(TemporalEngine.Data.Duration.duration(seconds: seconds, nanos: nanos)) do
    %__MODULE__{seconds: seconds, nanos: nanos}
  end
end
