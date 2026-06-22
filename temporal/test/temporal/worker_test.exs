defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.Worker

  setup_all [:setup_create_client]

  test "initializes for a task queue", ctx do
    assert {:ok, _worker} = Worker.new(ctx.client, task_queue: ctx.task_queue)
  end

  test "shuts down in a reasonable time", ctx do
    {:ok, worker} = Worker.new(ctx.client, task_queue: ctx.task_queue)

    parent = self()

    spawn_link(fn ->
      send(parent, {:shutdown_result, Worker.shutdown(worker)})
    end)

    assert_receive {:shutdown_result, :ok}, 300
  end

  defp setup_create_client(ctx) do
    {:ok, runtime} = Temporal.Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", identity: "#{__MODULE__}", runtime: runtime)

    Map.merge(ctx, %{client: client, task_queue: "#{__MODULE__}"})
  end
end
