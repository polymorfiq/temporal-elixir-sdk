defmodule Temporal.Workflows.BasicTest do
  use ExUnit.Case

  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivationCompletion

  alias Temporal.TaskQueue
  alias TestWorkflows.ActivitiesWithAwait
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Mock.Worker, as: WorkerMock

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  test "should send the correct messages at the correct time", ctx do
    TaskQueue.start_workflow(
      ctx.queue,
      "sends-basic-messages",
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

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
