defmodule Temporal.WorkflowTest do
  use ExUnit.Case
  doctest Temporal.Workflow
  alias Temporal.Client
  alias Temporal.TaskQueue
  alias Temporal.Workflow
  alias Temporal.Worker

  setup_all [:setup_create_task_queue]

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

    #    test "responds appropriately", %{queue: queue} do
    #      {:ok, handle} =
    #        TaskQueue.start_workflow(queue, unique_name("can-be-started"), StartableNoArgs, [])
    #
    #      assert {:ok, "Hello"} = Temporal.Workflow.watch_result(handle)
    #    end
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

  describe "polling activations" do
    defmodule ShouldRunSuccessfully do
      use Temporal.Workflow

      def execute(_ctx, msg) do
        {:ok, "Hello, #{msg}!"}
      end
    end

    test "receives started workflow activations", %{client: client} do
      queue = create_basic_queue(client, "polling_activations_1")
      {:ok, _} = Worker.new(queue, forward_polled_messages: self())

      workflow_id = unique_name("receives-workflow-activations")
      {:ok, _} = TaskQueue.start_workflow(queue, workflow_id, ShouldRunSuccessfully, ["World!"])

      assert_receive {:workflow_activation_job,
                      {:initialize_workflow, %{workflow_id: ^workflow_id}}, _},
                     5000
    end

    test "completes workflow activations", %{client: client} do
      queue = create_basic_queue(client, "polling_activations_2")
      {:ok, worker} = Worker.new(queue, forward_polled_messages: self())
      :ok = Worker.register_workflow(worker, ShouldRunSuccessfully)

      workflow_id = unique_name("completes-workflow")
      {:ok, handle} = Workflow.start(queue, workflow_id, ShouldRunSuccessfully, ["World!"])

      parent = self()

      child =
        spawn_link(fn ->
          result = Workflow.get(handle)
          send(parent, {self(), result})
        end)

      assert_receive {^child, {:ok, "Hello, World!!"}}, 5000
    end
  end

  describe "with activities" do
    defmodule WorkflowWithActivities do
      use Temporal.Workflow, activities: [activity_1: 2]
      alias Temporal.Workflow

      def execute(ctx, msg) do
        {:ok, act1} =
          Workflow.execute_activity(ctx, &activity_1/2, [msg],
            start_to_close_timeout: {1, :seconds}
          )

        Workflow.get(ctx, act1)
      end

      def activity_1(_ctx, msg) do
        {:ok, "Hello, #{msg}!"}
      end
    end

    test "executes correct activity and gets response", %{client: client} do
      queue = create_basic_queue(client, "activities_1")
      {:ok, worker} = Worker.new(queue, forward_polled_messages: self())
      :ok = Worker.register_workflow(worker, WorkflowWithActivities)

      workflow_id = unique_name("workflow-with-activities")

      {:ok, handle} =
        TaskQueue.start_workflow(queue, workflow_id, WorkflowWithActivities, ["World!"])

      parent = self()

      child =
        spawn_link(fn ->
          result = Workflow.get(handle)
          send(parent, {self(), result})
        end)

      assert_receive {^child, {:ok, "Hello, World!!"}}, 5000
    end
  end

  defp setup_create_task_queue(ctx) do
    {:ok, client} = Client.new("localhost:7233")

    queue = create_basic_queue(client, "workflow_test")

    Map.merge(ctx, %{
      client: client,
      queue: queue
    })
  end

  defp create_basic_queue(client, name) do
    TaskQueue.new(client, name,
      default_workflow_opts: [
        id_conflict_policy: :terminate_existing,
        run_timeout: {5, :seconds}
      ]
    )
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
