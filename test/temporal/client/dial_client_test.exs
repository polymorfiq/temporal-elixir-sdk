defmodule Temporal.Client.DialClientTest do
  use ExUnit.Case
  doctest Temporal.Client.DialClient

  import Mock

  alias Temporal.Client.DialClient

  test "can connect to local Temporal instance with default opts" do
    {:ok, dc} = DialClient.new("localhost:7233")

    assert Temporal.Client.namespace(dc) == "default"
  end

  test "propagates worker options" do
    {:ok, dc} = DialClient.new("localhost:7233", worker_heartbeat_interval: {12, :second})

    assert Temporal.Client.worker_heartbeat_interval(dc) == {12, :second}
  end

  test "fails when unable to connect to instance" do
    with_mock GRPC.Stub, connect: fn _url -> {:error, :timeout} end do
      {:error, _} = DialClient.new("localhost:36345")
    end
  end
end
