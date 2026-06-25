defmodule TemporalEngine.Data.Duration do
  use TemporalEngine.Data.TypeSpec

  alias Duration, as: NativeDuration
  alias TemporalEngine.Data.Duration

  deftype :duration do
    @opts_type :: Duration.shorthand() | NativeDuration.t()

    @default 0
    @type seconds :: required :: integer()

    @default 0
    @type nanos :: required :: integer()

    @spec validate_opts(opts(), path :: String.t()) :: {:ok, t()} | {:error, term()}
    def validate_opts(opts, path) do
      with {:ok, _} <- from_opts(opts) do
        {:ok, opts}
      else
        {:error, _} ->
          {:error,
           [
             "Expected '#{inspect(path)}' to be '{number, unit}' like '{5, :seconds}' but received '#{inspect(opts)}'"
           ]}
      end
    end

    @spec from_opts(opts()) :: {:ok, t()} | {:error, term()}
    def from_opts(opts), do: from_tuple(opts)
  end

  @type shorthand ::
          {pos_integer(),
           :weeks | :days | :hours | :minutes | :seconds | :milliseconds | :microseconds}

  @spec from_tuple(shorthand() | NativeDuration.t()) :: {:ok, duration()} | {:error, term()}
  defp from_tuple({weeks, :weeks}) when is_integer(weeks),
    do: {:ok, NativeDuration.new!(week: weeks) |> from_native()}

  defp from_tuple({days, :days}) when is_integer(days),
    do: {:ok, NativeDuration.new!(day: days) |> from_native()}

  defp from_tuple({hours, :hours}) when is_integer(hours),
    do: {:ok, NativeDuration.new!(hour: hours) |> from_native()}

  defp from_tuple({minutes, :minutes}) when is_integer(minutes),
    do: {:ok, NativeDuration.new!(minute: minutes) |> from_native()}

  defp from_tuple({seconds, :seconds}) when is_integer(seconds),
    do: {:ok, NativeDuration.new!(second: seconds) |> from_native()}

  defp from_tuple({milli, :milliseconds}) when is_integer(milli),
    do: {:ok, NativeDuration.new!(microsecond: {milli * 1_000, 6}) |> from_native()}

  defp from_tuple({micro, :microseconds}) when is_integer(micro),
    do: {:ok, NativeDuration.new!(microsecond: {micro, 6}) |> from_native()}

  defp from_tuple(%NativeDuration{} = duration), do: from_native(duration)

  defp from_tuple(other),
    do:
      {:error,
       "Duration expected {quantity, unit()) such as {5, :seconds}. Got: #{inspect(other)}"}

  @spec to_tuple(duration()) :: shorthand()
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

  @spec to_milliseconds(duration()) :: integer
  def to_milliseconds(duration(seconds: seconds, nanos: nanos)) do
    seconds * 1000 + Integer.floor_div(nanos, 1_000_000)
  end

  def from_native(%NativeDuration{} = duration) do
    if duration.month > 0 || duration.year > 0 do
      raise "Durations may not contain years or months, as those durations are very variable. Stick to weeks or below."
    end

    seconds = 0
    seconds = seconds + duration.week * 86400 * 7
    seconds = seconds + duration.day * 86400
    seconds = seconds + duration.hour * 3600
    seconds = seconds + duration.minute * 60
    seconds = seconds + duration.second

    %NativeDuration{microsecond: {micro, _precision}} = duration
    seconds = seconds + Integer.floor_div(micro, 1_000_000)
    nanos = Integer.mod(micro, 1_000_000) * 1_000
    duration(seconds: round(seconds), nanos: round(nanos))
  end
end
