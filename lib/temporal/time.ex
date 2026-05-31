defmodule Temporal.Time do
  @type time_interval() :: {integer(), :second | :millisecond}

  @spec ms(time_interval()) :: integer()
  def ms({secs, :second}), do: secs * 1000
  def ms({ms, :millisecond}), do: ms

  @spec secs(time_interval()) :: integer()
  def secs({secs, :second}), do: secs
  def secs({ms, :millisecond}), do: ms / 1000.0
end
