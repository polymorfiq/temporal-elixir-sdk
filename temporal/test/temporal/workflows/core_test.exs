defmodule Temporal.Workflows.CoreTest do
  use ExUnit.Case

  require TemporalEngine.Data.ActivationCompletion
  require TemporalEngine.Data.Jobs

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.ActivityTaskCompletion

  alias Temporal.TaskQueue
  alias TestWorkflows.ActivitiesWithAwait
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Mock.Worker, as: WorkerMock

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  test "can simulate a workflow", %{worker: worker, queue: queue} do
    TaskQueue.start_workflow(
      queue,
      "simulate-workflow",
      ActivitiesWithAwait,
      ["Testing"],
      id_conflict_policy: :terminate_existing
    )

    WorkerMock.forward_sent_commands(worker)
    WorkerMock.forward_received_jobs(worker)
    WorkerMock.forward_received_activations(worker)
    WorkerMock.forward_received_activity_tasks(worker)
    WorkerMock.set_silence_engine(worker, true)

    {:ok, run_id} =
      receive do
        {:activation, activation(run_id: run_id)} ->
          {:ok, run_id}
      after
        5000 -> {:error, "Did not receive activation"}
      end

    assert_receive {:job, Jobs.initialize_workflow()}, 1000

    WorkerMock.send_commands(worker, run_id, [
      schedule_activity(
        seq: 1,
        activity_id: "my-activity",
        activity_type: "my-activity-type",
        task_queue: queue.queue_name,
        arguments: [],
        schedule_to_close_timeout: Duration.from_tuple({5, :seconds})
      )
    ])

    {:ok, task_token} =
      receive do
        {:activity_task,
         activity_task(
           task_token: task_token,
           variant: start_activity(activity_type: "my-activity-type")
         )} ->
          {:ok, task_token}
      after
        5000 -> {:error, "Did not receive activity start"}
      end

    WorkerMock.send_activity_task_completion(
      worker,
      task_token,
      activity_completed(result: Payload.record_from_value("My test"))
    )

    assert_receive {:job,
                    Jobs.resolve_activity(
                      seq: 1,
                      result:
                        Jobs.activity_resolution(status: activity_completed(result: "My test"))
                    )},
                   1000

    WorkerMock.send_commands(worker, run_id, [
      complete_workflow_execution(result: Payload.record_from_value("Workflow output"))
    ])

    assert_receive {:job, Jobs.remove_from_cache(reason: :workflow_execution_ending)}, 1000
    WorkerMock.send_commands(worker, run_id, [])
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
