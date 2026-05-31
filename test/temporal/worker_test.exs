defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Worker

  setup_all do
    {:ok, client} = Temporal.DialClient.new(host_port: "localhost:7233")
    {:ok, client: client}
  end

  test "can be initialized with no options", %{client: c} do
    {:ok, _} = Worker.new(c, "default")
  end

  test "returns error when using reserved task queue", %{client: c} do
    {:error, _} = Worker.new(c, "__temporal_something")
  end
end
