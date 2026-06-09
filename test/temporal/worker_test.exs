defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.Runtime
  alias Temporal.TaskQueue
  alias Temporal.Worker

  setup [:setup_create_task_queue]

  test "initializes for a task queue", %{queue: queue} do
    assert {:ok, _worker} = Worker.new(queue)
  end

  defp setup_create_task_queue(ctx) do
    {:ok, runtime} = Temporal.Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    task_queue = TaskQueue.new(client, "default")
    Map.merge(ctx, %{queue: task_queue, client: client})
  end
end
