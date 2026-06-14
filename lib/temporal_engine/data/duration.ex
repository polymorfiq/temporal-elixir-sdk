defmodule TemporalEngine.Data.Duration do
  require Record

  Record.defrecord(:duration, [:seconds, :nanos])
  @type t :: record(:duration, seconds: integer(), nanos: integer())

  @type duration ::
          {pos_integer(),
           :weeks | :days | :hours | :minutes | :seconds | :milliseconds | :microseconds}

  @spec from_tuple(duration()) :: t()
  def from_tuple({weeks, :weeks}) when is_integer(weeks),
    do: Duration.new!(week: weeks) |> from_native()

  def from_tuple({days, :days}) when is_integer(days),
    do: Duration.new!(day: days) |> from_native()

  def from_tuple({hours, :hours}) when is_integer(hours),
    do: Duration.new!(hour: hours) |> from_native()

  def from_tuple({minutes, :minutes}) when is_integer(minutes),
    do: Duration.new!(minute: minutes) |> from_native()

  def from_tuple({seconds, :seconds}) when is_integer(seconds),
    do: Duration.new!(second: seconds) |> from_native()

  def from_tuple({milli, :milliseconds}) when is_integer(milli),
    do: Duration.new!(microsecond: {milli * 1_000, 6}) |> from_native()

  def from_tuple({micro, :microseconds}) when is_integer(micro),
    do: Duration.new!(microsecond: {micro, 6}) |> from_native()

  def from_tuple(%Duration{} = duration), do: from_native(duration)

  @spec to_tuple(t()) :: duration()
  def to_tuple(duration(seconds: seconds, nanos: nanos)) do
    cond do
      nanos === 0 && Integer.mod(seconds, 86400 * 7) == 0 ->
        {seconds / 86400 * 7, :weeks}

      nanos === 0 && Integer.mod(seconds, 86400) == 0 ->
        {seconds / 86400, :days}

      nanos === 0 && Integer.mod(seconds, 3600) == 0 ->
        {seconds / 3600, :hours}

      nanos === 0 && Integer.mod(seconds, 60) == 0 ->
        {seconds / 60, :minutes}

      nanos === 0 ->
        {seconds, :seconds}

      Integer.mod(seconds * 1_000_000_000 + nanos, 1_000_000) == 0 ->
        {(seconds * 1_000_000_000 + nanos) / 1_000_000, :milliseconds}

      true ->
        {(seconds * 1_000_000_000 + nanos) / 1_000, :microseconds}
    end
  end

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
    duration(seconds: round(seconds), nanos: round(nanos))
  end
end
