defmodule Temporal.ClientTest do
  use ExUnit.Case
  doctest Temporal.Client

  alias Temporal.Client
  alias Temporal.Runtime
  alias Temporal.Workflows.WorkflowHandle

  test "initializes with only target host" do
    assert {:ok, _client} = Client.new("localhost:7233")
  end

  test "allows custom identity option" do
    assert {:ok, _client} = Client.new("localhost:7233", identity: "my-identity")
  end

  test "allows custom namespace option" do
    {:ok, client} = Client.new("localhost:7233", namespace: "my-namespace")
    assert client.namespace == "my-namespace"
  end

  test "allows custom RPC options" do
    assert {:ok, _client} =
             Client.new("localhost:7233",
               rpc: [
                 initial_interval_secs: 30.0,
                 randomization_factor: 5.0,
                 multiplier: 2.0,
                 max_interval_secs: 60.0,
                 max_elapsed_time_secs: 60.0,
                 max_retries: 30
               ]
             )
  end

  test "has options validation" do
    assert {:error, {:invalid_opts, [:invalid_b, :invalid_a]}} =
             Client.new("localhost:7233",
               invalid_a: 123,
               invalid_b: 456
             )
  end

  describe "valid clients" do
    setup [:setup_create_client]

    test "can create a workflow handle", %{client: client} do
      assert %WorkflowHandle{} = Client.workflow(client, "MyWorkflow")
    end
  end

  defp setup_create_client(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", runtime: runtime, identity: "#{__MODULE__}")
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    Map.put(ctx, :client, client)
  end
end
