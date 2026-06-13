defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Runtime
  alias Temporal.TaskQueue
  alias Temporal.Worker

  setup_all [:setup_create_task_queue]
  setup [:stop_all_workers]

  test "initializes for a task queue", %{queue: queue} do
    assert {:ok, _worker} = Worker.new(queue)
  end

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
    sup_pid = Worker.worker_supervisor_pid(worker.id)
    ref = Process.monitor(sup_pid)

    Worker.shutdown(worker)

    assert_receive {:DOWN, ^ref, :process, ^sup_pid, _}, 1000
  end

  test "shuts down Core Worker when supervisor is stopped", ctx do
    {:ok, worker} = Worker.new(ctx.queue)
    {:ok, _} = CoreWorker.existing_for_id(worker.id)

    Worker.stop_with_id(worker.id)
    assert {:error, :core_worker_not_online} = CoreWorker.existing_for_id(worker.id)
  end

  defp stop_all_workers(ctx) do
    on_exit(fn ->
      Client.stop_all_workers(ctx.client)
    end)
  end

  defp setup_create_task_queue(ctx) do
    {:ok, runtime} = Temporal.Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", runtime: runtime, identity: "#{__MODULE__}")
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    task_queue = TaskQueue.new(client, "#{__MODULE__}")
    Map.merge(ctx, %{queue: task_queue, client: client})
  end
end
