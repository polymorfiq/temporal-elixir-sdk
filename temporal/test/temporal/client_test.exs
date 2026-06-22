defmodule Temporal.ClientTest do
  use ExUnit.Case
  doctest Temporal.Client

  alias Temporal.Client
  alias Temporal.Runtime

  setup [:setup_runtime]

  test "initializes with only target host", %{runtime: runtime} do
    assert {:ok, _client} = Client.new("localhost:7233", runtime: runtime)
  end

  test "allows custom identity option", %{runtime: runtime} do
    assert {:ok, _client} =
             Client.new("localhost:7233", identity: "my-identity", runtime: runtime)
  end

  test "allows custom namespace option", %{runtime: runtime} do
    {:ok, client} = Client.new("localhost:7233", namespace: "my-namespace", runtime: runtime)
    assert client.namespace == "my-namespace"
  end

  test "allows custom RPC options", %{runtime: runtime} do
    assert {:ok, _client} =
             Client.new(
               "localhost:7233",
               runtime: runtime,
               retry_options: [
                 initial_interval: [seconds: 30],
                 randomization_factor: 5.0,
                 multiplier: 2.0,
                 max_interval: [seconds: 60],
                 max_elapsed_time: [seconds: 60],
                 max_retries: 30
               ]
             )
  end

  test "has options validation", %{runtime: runtime} do
    assert {:error, [connection_opts: _]} =
             Client.new(
               "localhost:7233",
               invalid_a: 123,
               invalid_b: 456,
               runtime: runtime
             )
  end

  defp setup_runtime(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}")

    Map.put(ctx, :runtime, runtime)
  end
end
