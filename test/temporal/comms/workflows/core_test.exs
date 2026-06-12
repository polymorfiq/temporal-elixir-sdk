defmodule Temporal.CoreTest do
  use ExUnit.Case
  use ChannelHelpers
  doctest Temporal.Client

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias Temporal.Comms.Channel

  setup_all [:setup_worker]
  setup [:reroute_channel]

  test "can simulate a workflow", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      unique_name("core-test"),
      WorkflowWithActivities,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    {:ok, run_id} =
      receive do
        {:to_client, :activation, {:activation, run_id, _}} ->
          {:ok, run_id}
      after
        5000 -> {:error, "Did not receive activation"}
      end

    :ok =
      receive do
        {:to_client, :job, {:initialize_workflow, _run_id, _wf_type, _wf_args, _opts}} ->
          :ok
      after
        5000 -> {:error, "Did not receive initialization"}
      end

    Channel.send_to_engine(
      ctx.channel,
      ctx.worker,
      {:activation_completion, run_id,
       {:success,
        [
          {:schedule_activity, 1,
           %{
             activity_id: "my-activity",
             activity_type: "my-activity-type",
             task_queue: ctx.queue.queue_name,
             arguments: [],
             schedule_to_close_timeout: {5, :seconds}
           }}
        ]}}
    )

    {:ok, task_token} =
      receive do
        {:to_client, :activity_task, {{:start, _id, "my-activity-type", _opts}, task_token}} ->
          {:ok, task_token}
      after
        5000 -> {:error, "Did not receive activity start"}
      end

    Channel.send_to_engine(
      ctx.channel,
      ctx.worker,
      {:activity, :completed, {:json, Jason.encode!("My test")}, task_token}
    )

    assert_engine_sends_jobs(ctx, [
      {:resolve_activity, 1, {:completed, "My test"}, _}
    ])

    Channel.send_to_engine(
      ctx.channel,
      ctx.worker,
      {:activation_completion, run_id,
       {:success,
        [
          {:complete_workflow_execution, {:json, Jason.encode!("Workflow output")}}
        ]}}
    )

    assert_engine_sends_jobs(ctx, [{:remove_from_cache, :workflow_execution_ending, _}])
  end

  def setup_worker(ctx) do
    {:ok, runtime} = Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)

    queue = TaskQueue.new(client, "default")
    channel = Channel.new(queue)

    channel =
      channel |> Channel.silence_activity_tasks() |> Channel.silence_workflow_activations()

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
    Channel.add_listener(channel, test_pid, [:activation, :command, :job, :activity_task])
    on_exit(fn -> Channel.remove_listener(channel, test_pid) end)

    ctx
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
