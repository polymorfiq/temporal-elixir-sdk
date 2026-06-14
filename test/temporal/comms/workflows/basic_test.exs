defmodule Temporal.Workflows.BasicTest do
  use ExUnit.Case
  use ChannelHelpers

  require TestWorkflows.ActivitiesWithAwait
  require TestWorkflows.TimerWithAwait

  import TemporalEngine.Data.Jobs

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias Temporal.Comms.Channel
  alias TestWorkflows.{ActivitiesWithAwait, TimerWithAwait}

  setup_all [:setup_worker]
  setup [:reroute_channel]

  test "should send the correct messages at the correct time", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      unique_name("basic-test"),
      ActivitiesWithAwait,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    assert_engine_sends_jobs(ctx, [
      initialize_workflow(arguments: ["Testing"])
    ])

    assert_client_sends_commands(
      ctx,
      [
        {:schedule_activity, 1, %{activity_type: "activity_a", arguments: ["Testing1"]}},
        {:schedule_activity, 2, %{activity_type: "activity_b", arguments: ["Testing2"]}}
      ]
    )

    assert_engine_sends_jobs(ctx, [
      resolve_activity(seq: 1, result: activity_completed(result: "Hello, Testing1!")),
      resolve_activity(seq: 2, result: activity_completed(result: "Hello, Testing2!"))
    ])

    assert_client_sends_commands(ctx,
      complete_workflow_execution: "Hello, Testing2!"
    )

    assert_engine_sends_jobs(ctx, [remove_from_cache(reason: :workflow_execution_ending)])

    assert_client_sends_completion(ctx, {:activation_completion, _, {:success, []}})
  end

  test "should respect timers", ctx do
    TaskQueue.start_workflow(ctx.queue, unique_name("basic-test"), TimerWithAwait, [],
      id_conflict_policy: :terminate_existing
    )

    assert_engine_sends_jobs(ctx, [{:initialize_workflow, _id, "TimerWithAwait", [], _opts}])

    assert_engine_sends_jobs(ctx, [{:remove_from_cache, :workflow_execution_ending, _}])
  end

  def setup_worker(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", runtime: runtime, identity: "#{__MODULE__}")

    queue = TaskQueue.new(client, "#{__MODULE__}")
    channel = Channel.new(queue)

    {:ok, worker} = Worker.new(queue, channel)
    Worker.register_workflow(worker, ActivitiesWithAwait)
    Worker.register_workflow(worker, TimerWithAwait)

    on_exit(fn -> Worker.shutdown(worker) end)
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
    Channel.add_listener(channel, test_pid, [:command, :completion, :job])
    on_exit(fn -> Channel.remove_listener(channel, test_pid) end)

    ctx
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
