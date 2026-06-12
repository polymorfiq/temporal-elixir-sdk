defmodule Temporal.ClientTest do
  use ExUnit.Case
  doctest Temporal.Client

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias Temporal.Comms.Channel

  setup_all [:setup_worker]
  setup [:reroute_channel]

  defmacro assert_client_sends_commands(_ctx, cmd_patterns) do
    Enum.map(cmd_patterns, fn pattern ->
      quote do
        assert_receive {:to_engine, :command, unquote(pattern)}, 5000
      end
    end)
  end

  defmacro assert_engine_sends_jobs(_ctx, job_patterns) do
    Enum.map(job_patterns, fn pattern ->
      quote do
        assert_receive {:to_client, :job, unquote(pattern)}, 5000
      end
    end)
  end

  defmodule WorkflowWithActivities do
    use Temporal.Workflow,
      activities: [
        {:greet_activity, 2, [name: "activity_a"]},
        {:greet_activity, 2, [name: "activity_b"]}
      ]

    alias Temporal.Workflow

    def execute(ctx, msg) do
      {:ok, act1} =
        Workflow.execute_activity(ctx, "activity_a", ["#{msg}1"],
          start_to_close_timeout: {1, :seconds}
        )

      {:ok, act2} =
        Workflow.execute_activity(ctx, "activity_b", ["#{msg}2"],
          start_to_close_timeout: {1, :seconds}
        )

      Workflow.get(ctx, act1)
      Workflow.get(ctx, act2)
    end

    def greet_activity(_ctx, msg) do
      {:ok, "Hello, #{msg}!"}
    end
  end

  test "should send the correct messages at the correct time", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      unique_name("basic-test"),
      WorkflowWithActivities,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    assert_engine_sends_jobs(ctx, [
      {:initialize_workflow, _id, "WorkflowWithActivities", ["Testing"], _opts}
    ])

    assert_client_sends_commands(
      ctx,
      [
        {:schedule_activity, 1, %{activity_type: "activity_a", arguments: ["Testing1"]}},
        {:schedule_activity, 2, %{activity_type: "activity_b", arguments: ["Testing2"]}}
      ]
    )

    assert_engine_sends_jobs(ctx, [
      {:resolve_activity, 1, {:completed, "Hello, Testing1!"}, _},
      {:resolve_activity, 2, {:completed, "Hello, Testing2!"}, _}
    ])

    assert_client_sends_commands(ctx,
      complete_workflow_execution: "Hello, Testing2!"
    )
  end

  def setup_worker(ctx) do
    {:ok, runtime} = Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)

    queue = TaskQueue.new(client, "default")
    channel = Channel.new(queue)

    {:ok, worker} = Worker.new(queue, channel)
    Worker.register_workflow(worker, WorkflowWithActivities)

    on_exit(fn -> Worker.stop(worker) end)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    Map.merge(ctx, %{
      client: client,
      runtime: runtime,
      queue: queue,
      worker: worker,
      channel: channel
    })
  end

  defp reroute_channel(%{channel: channel} = ctx) do
    test_pid = self()
    Channel.add_listener(channel, test_pid, [:command, :job])
    on_exit(fn -> Channel.remove_listener(channel, test_pid) end)

    ctx
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
