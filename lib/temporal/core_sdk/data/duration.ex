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
    do: Timex.Duration.from_weeks(weeks) |> from_timex_duration()

  def with_opts!({days, :days}) when is_integer(days),
    do: Timex.Duration.from_days(days) |> from_timex_duration()

  def with_opts!({hours, :hours}) when is_integer(hours),
    do: Timex.Duration.from_hours(hours) |> from_timex_duration()

  def with_opts!({minutes, :minutes}) when is_integer(minutes),
    do: Timex.Duration.from_minutes(minutes) |> from_timex_duration()

  def with_opts!({micro, :seconds}) when is_integer(micro),
    do: Timex.Duration.from_seconds(micro) |> from_timex_duration()

  def with_opts!({micro, :milliseconds}) when is_integer(micro),
    do: Timex.Duration.from_milliseconds(micro) |> from_timex_duration()

  def with_opts!({micro, :microseconds}) when is_integer(micro),
    do: Timex.Duration.from_microseconds(micro) |> from_timex_duration()

  def with_opts!(%Timex.Duration{} = duration), do: from_timex_duration(duration)

  defp from_timex_duration(%Timex.Duration{} = duration) do
    seconds = Timex.Duration.to_seconds(duration)
    nanos = Integer.mod(Timex.Duration.to_microseconds(duration), 1_000_000) * 1000
    %__MODULE__{seconds: round(seconds), nanos: round(nanos)}
  end
end
