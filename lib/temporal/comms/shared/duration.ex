defmodule Temporal.Comms.Shared.Duration do
  defstruct [
    :seconds,
    :nanos
  ]

  @type duration ::
          {pos_integer(),
           :weeks | :days | :hours | :minutes | :seconds | :milliseconds | :microseconds}

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}

  @spec send_to_engine(duration()) :: t()
  def send_to_engine({weeks, :weeks}) when is_integer(weeks),
    do: Duration.new!(week: weeks) |> from_native()

  def send_to_engine({days, :days}) when is_integer(days),
    do: Duration.new!(day: days) |> from_native()

  def send_to_engine({hours, :hours}) when is_integer(hours),
    do: Duration.new!(hour: hours) |> from_native()

  def send_to_engine({minutes, :minutes}) when is_integer(minutes),
    do: Duration.new!(minute: minutes) |> from_native()

  def send_to_engine({seconds, :seconds}) when is_integer(seconds),
    do: Duration.new!(second: seconds) |> from_native()

  def send_to_engine({milli, :milliseconds}) when is_integer(milli),
    do: Duration.new!(microsecond: {milli * 1_000, 6}) |> from_native()

  def send_to_engine({micro, :microseconds}) when is_integer(micro),
    do: Duration.new!(microsecond: {micro, 6}) |> from_native()

  def send_to_engine(%Duration{} = duration), do: from_native(duration)

  def send_to_sdk(%__MODULE__{} = duration) do
    cond do
      duration.nanos === 0 && Integer.mod(duration.seconds, 86400 * 7) == 0 ->
        {duration.seconds / 86400 * 7, :weeks}

      duration.nanos === 0 && Integer.mod(duration.seconds, 86400) == 0 ->
        {duration.seconds / 86400, :days}

      duration.nanos === 0 && Integer.mod(duration.seconds, 3600) == 0 ->
        {duration.seconds / 3600, :hours}

      duration.nanos === 0 && Integer.mod(duration.seconds, 60) == 0 ->
        {duration.seconds / 60, :minutes}

      duration.nanos === 0 ->
        {duration.seconds, :seconds}

      Integer.mod(duration.seconds * 1_000_000_000 + duration.nanos, 1_000_000) == 0 ->
        {(duration.seconds * 1_000_000_000 + duration.nanos) / 1_000_000, :milliseconds}

      true ->
        {(duration.seconds * 1_000_000_000 + duration.nanos) / 1_000, :microseconds}
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
    %__MODULE__{seconds: round(seconds), nanos: round(nanos)}
  end
end
