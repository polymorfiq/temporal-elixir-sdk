defmodule TemporalGettingStarted.Workflows.FunctionBasedWorkflow do
  @moduledoc """
  This Workflow is defined solely within a function. It does not have to have a specific name or otherwise need for its containing module to `use` anything.
  """

  alias Temporal.{Workflow, WorkflowExecution}

  def function_based_workflow(ctx, multiply_me) do
    results = Workflow.execute_activity!(ctx, &function_based_activity/2, [multiply_me, 30])
    {:ok, multiplied} = WorkflowExecution.get(results)

    {:ok, multiplied}
  end

  def another_function_based_workflow(ctx, a, b) do
    results = Workflow.execute_activity!(ctx, &function_based_activity/2, [a, b])
    {:ok, multiplied} = WorkflowExecution.get(results)

    {:ok, multiplied}
  end

  def function_based_activity(a, b) do
    {:ok, a * b}
  end
end