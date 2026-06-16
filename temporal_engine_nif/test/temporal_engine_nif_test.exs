defmodule TemporalEngineNifTest do
  use ExUnit.Case
  doctest TemporalEngineNif

  test "greets the world" do
    assert TemporalEngineNif.hello() == :world
  end
end
