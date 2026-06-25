defmodule TemporalGettingStarted.Workflows.ModuleBasedWorkflow do
  use Temporal.Workflow, activities: [:multiply]
  alias Temporal.Workflow

  def execute(ctx, multiply_me) do
    {:ok, multiplied_by_5} = Workflow.execute_activity!(ctx, &multiply/2, [multiply_me, 5]) |> Workflow.get()
    {:ok, multiplied_by_15} = Workflow.execute_activity!(ctx, &multiply/2, [multiplied_by_5, 3]) |> Workflow.get()

    {:ok, "#{multiply_me} x 15 = #{multiplied_by_15}"}
  end

  def execute(ctx, a, b) do
    {:ok, multiplied} = Workflow.execute_activity!(ctx, &multiply/2, [a, b]) |> Workflow.get()
    {:ok, "#{a} x #{b} = #{multiplied}"}
  end

  def multiply(a, b) do
    {:ok, a, b}
  end
end