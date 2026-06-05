defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.TaskQueue
  alias Temporal.Worker

  setup [:setup_create_task_queue]

  test "initializes for a task queue", %{queue: queue} do
    assert {:ok, _worker} = Worker.new(queue)
  end

  defp setup_create_task_queue(ctx) do
    {:ok, client} = Client.new("localhost:7233")
    task_queue = TaskQueue.new(client, "default")
    Map.merge(ctx, %{queue: task_queue, client: client})
  end
end
