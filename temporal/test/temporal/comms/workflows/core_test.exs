defmodule Temporal.Workflows.CoreTest do
  use ExUnit.Case

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.ActivationCompletion
  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.ActivityTaskCompletion

  alias Temporal.TaskQueue
  alias TestWorkflows.ActivitiesWithAwait
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Mock.Worker, as: WorkerMock

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  test "can simulate a workflow", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      "simulate-workflow",
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

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
