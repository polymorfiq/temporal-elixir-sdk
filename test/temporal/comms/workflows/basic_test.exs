defmodule Temporal.Workflows.BasicTest do
  use ExUnit.Case
  use ChannelHelpers

  require TestWorkflows.ActivitiesWithAwait
  require TestWorkflows.TimerWithAwait
  require TemporalEngine.Data.ActivationCompletion

  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias TestWorkflows.{ActivitiesWithAwait, TimerWithAwait}
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Mock.Worker, as: WorkerMock

  setup_all [:setup_worker]

  test "should send the correct messages at the correct time", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      unique_name("basic-test"),
      ActivitiesWithAwait,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    WorkerMock.forward_sent_commands(ctx.mocked_worker)
    WorkerMock.forward_received_jobs(ctx.mocked_worker)

    assert_receive {:job, initialize_workflow(arguments: ["Testing"])}, 1000

    assert_receive {:command,
                    schedule_activity(
                      seq: 1,
                      activity_type: "activity_a",
                      arguments: ["Testing1"]
                    )},
                   1000

    assert_receive {:command,
                    schedule_activity(
                      seq: 2,
                      activity_type: "activity_b",
                      arguments: ["Testing2"]
                    )},
                   1000

    assert_receive {:job,
                    resolve_activity(
                      seq: 1,
                      result: activity_completed(result: "Hello, Testing1!")
                    )},
                   1000

    assert_receive {:job,
                    resolve_activity(
                      seq: 2,
                      result: activity_completed(result: "Hello, Testing2!")
                    )},
                   1000

    assert_receive {:command, complete_workflow_execution(result: "Hello, Testing2!")}, 1000
    assert_receive {:job, remove_from_cache(reason: :workflow_execution_ending)}, 1000

    WorkerMock.forward_sent_completions(ctx.mocked_worker)

    assert_receive {:completion,
                    ActivationCompletion.completion(
                      result: ActivationCompletion.success(commands: [])
                    )},
                   1000
  end

  test "should respect timers", ctx do
#    WorkerMock.forward_received_jobs(ctx.mocked_worker)
#
#    TaskQueue.start_workflow(ctx.queue, unique_name("basic-test"), TimerWithAwait, [],
#      id_conflict_policy: :terminate_existing
#    )
#
#    assert_receive {:job, initialize_workflow(workflow_type: "TimerWithAwait")}, 1000
#    assert_receive {:job, remove_from_cache(reason: :workflow_execution_ending)}, 1000
  end

  def setup_worker(ctx) do
    {:ok, runtime} = Runtime.with_id("#{__MODULE__}", engine: TemporalEngine.Mock.Engine)
    {:ok, client} = Client.new("localhost:7233", runtime: runtime, identity: "#{__MODULE__}")

    queue = TaskQueue.new(client, "#{__MODULE__}")

    {:ok, worker} =
      Worker.new(queue,
        max_cached_workflows: 100,
        deployment_options: [
          version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
          use_worker_versioning: false,
          default_versioning_behavior: nil
        ],
        task_types: [
          enable_workflows: true,
          enable_local_activities: true,
          enable_remote_activities: true
        ],
        tuner: [
          workflow_slot_supplier: [fixed_size: 10],
          activity_slot_supplier: [fixed_size: 10],
          local_activity_slot_supplier: [fixed_size: 10]
        ]
      )

    Worker.register_workflow(worker, ActivitiesWithAwait)
    Worker.register_workflow(worker, TimerWithAwait)

    on_exit(fn -> Worker.shutdown(worker) end)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    {:ok, mocked_worker} = WorkerMock.mocked_for_id(worker.id)

    Map.merge(ctx, %{
      client: client,
      runtime: runtime,
      queue: queue,
      worker: worker,
      mocked_worker: mocked_worker
    })
  end

  defp unique_name(base_name) do
    "#{base_name}-#{System.unique_integer([:monotonic])}"
  end
end
