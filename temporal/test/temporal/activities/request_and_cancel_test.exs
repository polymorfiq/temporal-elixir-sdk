defmodule Temporal.Activities.RequestAndCancelTest do
  use ExUnit.Case

#  require Logger
#
#  import TemporalEngine.Data.Commands
#
#  alias Temporal.{TaskQueue, Workflow}
#  alias TemporalEngine.Mock.Worker, as: WorkerMock
#
#  setup_all [
#    :configure_task_queue,
#    {WorkflowHelpers, :setup_client},
#    {WorkflowHelpers, :setup_worker}
#  ]

#  test "allows cancellation of tasks", %{worker: worker, queue: queue} do
#    {:ok, wf} =
#      TaskQueue.start_workflow(
#        queue,
#        "request-cancel-activity",
#        {TestWorkflows.Activities, :workflow_with_long_activity},
#        [],
#        id_conflict_policy: :terminate_existing
#      )
#
#    Process.sleep(100)
#    {:ok, run_id} = WorkerMock.latest_run_id(wf)
#
#    WorkerMock.send_commands(worker, run_id, [request_cancel_activity(seq: 1)])
#
#    assert 123 = Workflow.result(wf)
#  end

#  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
