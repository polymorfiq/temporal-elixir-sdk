defmodule Temporal.CoreSdk.Data.Duration do
  defstruct [
    :seconds,
    :nanos
  ]

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}
  @type opts ::
          {integer(), :microseconds}
          | {integer(), :milliseconds}
          | {integer(), :seconds}
          | {integer(), :minutes}
          | {integer(), :hours}
          | {integer(), :days}
          | {integer(), :weeks}
          | Timex.Duration.t()

  @spec with_opts!(opts()) :: t()
  def with_opts!({weeks, :weeks}) when is_integer(weeks),
    do: Duration.new!(week: weeks) |> from_native()

  def with_opts!({days, :days}) when is_integer(days),
    do: Duration.new!(day: days) |> from_native()

  def with_opts!({hours, :hours}) when is_integer(hours),
    do: Duration.new!(hour: hours) |> from_native()

  def with_opts!({minutes, :minutes}) when is_integer(minutes),
    do: Duration.new!(minute: minutes) |> from_native()

  def with_opts!({seconds, :seconds}) when is_integer(seconds),
    do: Duration.new!(second: seconds) |> from_native()

  def with_opts!({milli, :milliseconds}) when is_integer(milli),
    do: Duration.new!(microsecond: milli * 1_000) |> from_native()

  def with_opts!({micro, :microseconds}) when is_integer(micro),
    do: Duration.new!(microsecond: {micro, 6}) |> from_native()

  def with_opts!(%Duration{} = duration), do: from_native(duration)

  def from_native(%Duration{} = duration) do
    if duration.month > 0 || duration.year > 0 do
      raise "Durations may not contain years or months, as those durations are very variable. Stick to weeks or below."
    end

    seconds = 0
    seconds = seconds + duration.week * 86400 * 7
    seconds = seconds + duration.day * 86400
    seconds = seconds + duration.hour * 3600
    seconds = seconds + duration.minute * 60
    seconds = seconds + duration.second

    %Duration{microsecond: {micro, _precision}} = duration
    seconds = seconds + Integer.floor_div(micro, 1_000_000)
    nanos = Integer.mod(micro, 1_000_000) * 1_000
    %__MODULE__{seconds: round(seconds), nanos: round(nanos)}
  end
end
