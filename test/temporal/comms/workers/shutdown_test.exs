defmodule Temporal.Workers.ShutdownTest do
  use ExUnit.Case
  use ChannelHelpers

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias Temporal.CoreSdk.CoreWorker

  setup_all [:setup_worker]

  test "shuts down in a reasonable time", ctx do
    {:ok, worker} = Worker.new(ctx.queue)

    parent = self()
    spawn_link(fn ->
      send(parent, {:shutdown_result, Worker.shutdown(worker)})
    end)

    assert_receive {:shutdown_result, :ok}, 300
  end

  test "stops worker supervisor when Core Worker is shutdown", ctx do
    {:ok, worker} = Worker.new(ctx.queue)
    Worker.shutdown(worker)
    Process.sleep(1000)

    assert false == Worker.alive_with_id?(worker.id)
  end

  test "shuts down Core Worker when supervisor is stopped", ctx do
    {:ok, worker} = Worker.new(ctx.queue)
    {:ok, _} = CoreWorker.existing_for_id(worker.id)

    Worker.stop_with_id(worker.id)
    assert {:error, :core_worker_not_online} = CoreWorker.existing_for_id(worker.id)
  end

  def setup_worker(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)
    queue = TaskQueue.new(client, "#{__MODULE__}")

    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    Map.merge(ctx, %{
      queue: queue,
      client: client,
      runtime: runtime
    })
  end
end
