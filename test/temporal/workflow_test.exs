defmodule Temporal.WorkflowTest do
  use ExUnit.Case
  doctest Temporal.Workflow
  alias Temporal.Client
  alias Temporal.TaskQueue
  alias Temporal.CoreSdk.Data.WorkflowActivation
  alias Temporal.Worker

  describe "with no arguments" do
    setup [:setup_create_task_queue]

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
    setup [:setup_create_task_queue]

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
    setup [:setup_create_task_queue]

    test "receives started workflow activations", %{client: client} do
      workflow_id = unique_name("receives-workflow-activations")

      queue =
        TaskQueue.new(client, "receiving_workflow_test",
          default_workflow_opts: [
            id_conflict_policy: :terminate_existing,
            run_timeout: {5, :seconds}
          ]
        )

      parent = self()

      child =
        spawn_link(fn ->
          {:ok, _worker} = Worker.new(queue, forward_polled_messages: self())

          receive do
            {:process_workflow_activation, activation} ->
              send(parent, {self(), activation})

            some_msg ->
              send(parent, {self(), some_msg})
          end
        end)

      {:ok, _} = TaskQueue.start_workflow(queue, workflow_id, StartableWithInputs, ["World!"])

      check_for_resp = fn on_not_match ->
        receive do
          {^child, %WorkflowActivation{jobs: jobs}} ->
            did_see =
              Enum.reduce(jobs, false, fn job, found ->
                found ||
                  match?(%{variant: {:initialize_workflow, %{workflow_id: ^workflow_id}}}, job)
              end)

            if did_see, do: {:ok, true}, else: on_not_match.()
        after
          5000 -> {:error, "Did not receive initialization job in time!"}
        end
      end

      assert {:ok, _} = check_for_resp.(check_for_resp)
    end
  end

  defp setup_create_task_queue(ctx) do
    {:ok, client} = Client.new("localhost:7233")

    queue =
      TaskQueue.new(client, "workflow_test",
        default_workflow_opts: [
          id_conflict_policy: :terminate_existing,
          run_timeout: {5, :seconds}
        ]
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
