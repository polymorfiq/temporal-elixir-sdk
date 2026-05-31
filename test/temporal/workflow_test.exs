defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  import Mock

  alias Temporal.Client
  alias Temporal.Worker
  alias Temporal.Comms.Worker.WorkerHeartbeatComms

  setup_all do
    {:ok, client} = Temporal.dial_client("localhost:7233")

    on_exit(fn ->
      Client.stop_workers(client)
    end)

    {:ok, client: client}
  end

  test "can be initialized with no options", %{client: c} do
    {:ok, w} = Worker.new(c, "default")

    defmodule MyWorkflow do
      def execute(ctx) do
        {:ok, "response"}
      end
    end

    Worker.register_workflow(w, MyWorkflow)
  end

  test "returns error when using reserved task queue", %{client: c} do
    {:error, _} = Worker.new(c, "__temporal_something")
  end

  test "heartbeats at client-configured interval" do
    with_mock WorkerHeartbeatComms, send_heartbeat: fn _client, _hb -> :ok end do
      {:ok, client} =
        Temporal.dial_client("localhost:7233", worker_heartbeat_interval: {100, :millisecond})

      {:ok, worker} = Worker.new(client, "default")

      Process.sleep(1100)

      assert_called_at_least(WorkerHeartbeatComms.send_heartbeat(:_, :_), 10)
      Worker.stop(worker)
    end

    with_mock WorkerHeartbeatComms, send_heartbeat: fn _client, _hb -> :ok end do
      {:ok, client} =
        Temporal.dial_client("localhost:7233", worker_heartbeat_interval: {1, :second})

      {:ok, _worker} = Worker.new(client, "default")

      Process.sleep(500)

      assert_called_exactly(WorkerHeartbeatComms.send_heartbeat(:_, :_), 1)
    end
  end
end
