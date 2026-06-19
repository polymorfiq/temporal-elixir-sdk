defmodule Temporal.Queries.BasicTest do
  use ExUnit.Case

  require Logger

  #  alias Temporal.{TaskQueue, Workflow}

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  #  test "can set query handler", %{queue: queue} do
  #    {:ok, wf} =
  #      TaskQueue.start_workflow(
  #        queue,
  #        "set-query-handler",
  #        TestWorkflows.Queries,
  #        [],
  #        id_conflict_policy: :terminate_existing
  #      )
  #
  #    assert {:ok, 456} = Workflow.result(wf)
  #  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
