defmodule Temporal.CoreSdk.CoreRuntimeTest do
  use ExUnit.Case
  doctest Temporal.CoreSdk.CoreRuntime

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.RuntimeOpts

  test "runs without options" do
    {:ok, _} = CoreRuntime.new()
  end

  test "runs with options" do
    {:ok, _} =
      CoreRuntime.new(%RuntimeOpts{
        heartbeat_interval_secs: 30
      })
  end
end
