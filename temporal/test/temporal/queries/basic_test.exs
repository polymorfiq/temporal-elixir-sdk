defmodule Temporal.Queries.BasicTest do
  use ExUnit.Case

  require Logger

  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  test "can create and utilize a query handler", ctx do
    {:ok, wf} =
      Temporal.Client.execute_workflow(
        ctx.client,
        TestWorkflows.Queries,
        [],
        workflow_id: "set-query-handler",
        id_conflict_policy: :terminate_existing,
        task_queue: ctx.task_queue
      )

    assert {:ok, "No args!"} = Temporal.Client.query_workflow(wf, :no_args)
    assert {:ok, "Args: 123"} = Temporal.Client.query_workflow(wf, :with_args, [123])
    assert {:error, _} = Temporal.Client.query_workflow(wf, :with_args, [:too, :many, :args])
    assert {:error, _} = Temporal.Client.query_workflow(wf, :not_real_query_handler)

    assert {:error, %{message: ~s|%RuntimeError{message: "Some exception"}|}} =
             Temporal.Client.query_workflow(wf, :throws_exeception)

    assert {:error, "Some error"} = Temporal.Client.query_workflow(wf, :returns_error)
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
