defmodule TemporalGettingStarted.Workflows.WorkflowWithChildren do
  alias Temporal.Workflow

  def parent_workflow(ctx) do
    ctx =
      Workflow.with_child_workflow_opts(ctx,
        workflow_execution_timeout: {10, :minutes},
        workflow_task_timeout: {1, :minutes},
        parent_close_policy: :abandon
      )

    child1 =
      Workflow.execute_child_workflow!(ctx, &child_workflow_1/2, ["Child 1"], id: "child_1")

    child2 =
      Workflow.execute_child_workflow!(ctx, &child_workflow_2/2, ["Child 2"], id: "child_2")

    {:ok, _child_1_we} = Workflow.get_child_workflow_execution(child1)
    {:ok, _child_2_we} = Workflow.get_child_workflow_execution(child2)

    {:ok, result_1} = Workflow.get(ctx, child1)
    {:ok, result_2} = Workflow.get(ctx, child2)

    {:ok, [result_1, result_2]}
  end

  def child_workflow_1(ctx, arg) do
    Workflow.sleep(ctx, 3000)
    {:ok, "Processed: #{arg}"}
  end

  def child_workflow_2(ctx, arg) do
    Workflow.sleep(ctx, 1000)
    {:ok, "Processed: #{arg}"}
  end
end
