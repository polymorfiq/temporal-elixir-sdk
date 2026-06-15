defmodule Temporal.Workflows.CoreTest do
  use ExUnit.Case
  use ChannelHelpers

  require TestWorkflows.ActivitiesWithAwait

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.ActivityTaskCompletion

  alias Temporal.{Client, Runtime, TaskQueue, Worker}
  alias TestWorkflows.ActivitiesWithAwait
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Mock.Worker, as: WorkerMock

  setup_all [:setup_worker]

  test "can simulate a workflow", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      unique_name("core-test"),
      ActivitiesWithAwait,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    WorkerMock.forward_sent_commands(ctx.mocked_worker)
    WorkerMock.forward_received_jobs(ctx.mocked_worker)
    WorkerMock.forward_received_activations(ctx.mocked_worker)
    WorkerMock.forward_received_activity_tasks(ctx.mocked_worker)
    WorkerMock.set_silence_engine(ctx.mocked_worker, true)

    {:ok, run_id} =
      receive do
        {:activation, activation(run_id: run_id)} ->
          {:ok, run_id}
      after
        5000 -> {:error, "Did not receive activation"}
      end

    assert_receive {:job, initialize_workflow()}, 1000

    WorkerMock.send_commands(ctx.mocked_worker, run_id, [
      schedule_activity(
        seq: 1,
        activity_id: "my-activity",
        activity_type: "my-activity-type",
        task_queue: ctx.queue.queue_name,
        arguments: [],
        schedule_to_close_timeout: Duration.from_tuple({5, :seconds})
      )
    ])

    {:ok, task_token} =
      receive do
        {:activity_task,
         start_activity(activity_type: "my-activity-type", task_token: task_token)} ->
          {:ok, task_token}
      after
        5000 -> {:error, "Did not receive activity start"}
      end

    WorkerMock.send_activity_task_completion(
      ctx.mocked_worker,
      task_completed(payload: Payload.record_from_value("My test"), task_token: task_token)
    )

    assert_receive {:job,
                    resolve_activity(
                      seq: 1,
                      result: activity_completed(result: "My test")
                    )},
                   1000

    WorkerMock.send_commands(ctx.mocked_worker, run_id, [
      complete_workflow_execution(result: Payload.record_from_value("Workflow output"))
    ])

    assert_receive {:job, remove_from_cache(reason: :workflow_execution_ending)}, 1000
    WorkerMock.send_commands(ctx.mocked_worker, run_id, [])
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

    {:ok, mocked_worker} = WorkerMock.mocked_for_id(worker.id)

    on_exit(fn -> Worker.shutdown(worker) end)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

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
