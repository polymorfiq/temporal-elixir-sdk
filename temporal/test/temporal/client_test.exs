defmodule Temporal.ClientTest do
  use ExUnit.Case
  doctest Temporal.Client

  alias Temporal.Client
  alias Temporal.Runtime
  alias Temporal.Workflows.WorkflowHandle

  setup [:setup_runtime]

  test "initializes with only target host", %{runtime: runtime} do
    assert {:ok, _client} = Client.new("localhost:7233", [], runtime: runtime)
  end

  test "allows custom identity option", %{runtime: runtime} do
    assert {:ok, _client} =
             Client.new("localhost:7233", [identity: "my-identity"], runtime: runtime)
  end

  test "allows custom namespace option", %{runtime: runtime} do
    {:ok, client} = Client.new("localhost:7233", [namespace: "my-namespace"], runtime: runtime)
    assert client.namespace == "my-namespace"
  end

  test "allows custom RPC options", %{runtime: runtime} do
    assert {:ok, _client} =
             Client.new(
               "localhost:7233",
               [
                 retry_options: [
                   initial_interval: [seconds: 30],
                   randomization_factor: 5.0,
                   multiplier: 2.0,
                   max_interval: [seconds: 60],
                   max_elapsed_time: [seconds: 60],
                   max_retries: 30
                 ]
               ],
               runtime: runtime
             )
  end

  test "has options validation", %{runtime: runtime} do
    assert {:error, {:invalid_opts, _}} =
             Client.new(
               "localhost:7233",
               [invalid_a: 123, invalid_b: 456],
               runtime: runtime
             )
  end

  describe "valid clients" do
    setup [:setup_create_client]

    test "can create a workflow handle", %{client: client} do
      assert %WorkflowHandle{} = Client.workflow(client, "MyWorkflow")
    end
  end

  defp setup_runtime(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}")
    on_exit(fn -> Runtime.stop(runtime) end)

    Map.put(ctx, :runtime, runtime)
  end

  defp setup_create_client(ctx) do
    {:ok, client} =
      Client.new("localhost:7233", [identity: "#{__MODULE__}"], runtime: ctx.runtime)

    on_exit(fn -> Client.stop(client) end)

    Map.put(ctx, :client, client)
  end
end
