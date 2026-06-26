defmodule Temporal.DeterminismTest do
  use ExUnit.Case

  require Logger

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  test "Workflow.utc_now executes and returns reasonable result", ctx do
    {:ok, we} =
      Temporal.Client.execute_workflow(
        ctx.client,
        TestWorkflows.Determinism,
        [],
        id: "workflow-utc-now",
        id_conflict_policy: :terminate_existing,
        task_queue: ctx.task_queue
      )

    assert {:ok, now} = Temporal.WorkflowExecution.get(we)
    assert_in_delta DateTime.diff(now, DateTime.utc_now()), 0, 2
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
