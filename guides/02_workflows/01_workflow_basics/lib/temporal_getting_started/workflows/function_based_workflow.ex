defmodule TemporalGettingStarted.Workflows.FunctionBasedWorkflow do
  @moduledoc """
  This Workflow is defined solely within a function. It does not have to have a specific name or otherwise need for its containing module to `use` anything.

  You need to be more explicit when registering activities and workflows declared in this way, but it can be helpful when creating many different related workflows.

  Function-based workflows can also be useful when definining a workflow in an otherwise unrelated module.
  """

  alias Temporal.{Workflow, WorkflowContext}

  def function_based_workflow(ctx, multiply_me) do
    ctx = prepare_context(ctx)
    results = Workflow.execute_activity!(ctx, &function_based_activity/2, [multiply_me, 30])
    {:ok, multiplied} = Workflow.get(ctx, results)

    {:ok, multiplied}
  end

  def another_function_based_workflow(ctx, a, b) do
    ctx = prepare_context(ctx)
    results = Workflow.execute_activity!(ctx, &function_based_activity/2, [a, b])
    {:ok, multiplied} = Workflow.get(ctx, results)

    {:ok, multiplied}
  end

  def function_based_activity(a, b) do
    {:ok, a * b}
  end

  #
  # Function-based workflows can freely share private convenience functions
  #
  @spec prepare_context(WorkflowContext.t()) :: WorkflowContext.t()
  defp prepare_context(ctx) do
    Workflow.with_activity_opts(ctx, start_to_close_timeout: {10, :seconds})
  end
end