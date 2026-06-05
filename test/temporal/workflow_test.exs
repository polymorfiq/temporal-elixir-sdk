defmodule Temporal.WorkflowTest do
  use ExUnit.Case
  doctest Temporal.Workflow
  alias Temporal.Client
  alias Temporal.TaskQueue

  setup [:setup_create_task_queue]

  describe "with no arguments" do
    defmodule StartableNoArgs do
      use Temporal.Workflow

      def execute(_ctx) do
        {:ok, "Hello"}
      end
    end

    test "can be started", %{queue: queue} do
      assert {:ok, _} =
               TaskQueue.start_workflow(queue, unique_name("can-be-started"), StartableNoArgs, [])
    end

    test "errors with invalid input arity", %{queue: queue} do
      assert {:error, "StartableNoArgs workflow does not implement execute/2"} =
               TaskQueue.start_workflow(queue, unique_name("can-be-started"), StartableNoArgs, [
                 "wrong"
               ])
    end
  end

  describe "with inputs" do
    defmodule StartableWithInputs do
      use Temporal.Workflow

      def execute(_ctx, msg) do
        {:ok, "Hello, #{msg}!"}
      end
    end

    test "can take inputs", %{queue: queue} do
      assert {:ok, _} =
               TaskQueue.start_workflow(
                 queue,
                 unique_name("can-take-inputs"),
                 StartableWithInputs,
                 ["World"]
               )
    end

    test "errors with no inputs", %{queue: queue} do
      assert {:error, "StartableWithInputs workflow does not implement execute/1"} =
               TaskQueue.start_workflow(
                 queue,
                 unique_name("can-take-inputs"),
                 StartableWithInputs,
                 []
               )
    end
  end

  defp setup_create_task_queue(ctx) do
    {:ok, client} = Client.new("localhost:7233")

    queue =
      TaskQueue.new(client, "workflow_test",
        default_workflow_opts: [id_conflict_policy: :terminate_existing]
      )

    Map.merge(ctx, %{
      client: client,
      queue: queue
    })
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
