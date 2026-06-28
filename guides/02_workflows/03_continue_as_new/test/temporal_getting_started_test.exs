defmodule TemporalGettingStartedTest do
  use ExUnit.Case
  doctest TemporalGettingStarted

  test "greets the world" do
    assert TemporalGettingStarted.hello() == :world
  end
end
