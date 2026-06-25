defmodule TemporalSamples.Workflows.LocalActivities do
  use Temporal.Workflow, activities: [:greet]
  alias Temporal.Workflow

  @spec execute(Workflow.WorkflowContext.t(), String.t()) :: {:ok, String.t()}
  def execute(ctx, name) do
    {:ok, act1} =
      Workflow.execute_local_activity(ctx, &greet/2, [name], start_to_close_timeout: [seconds: 1])

    Workflow.get(ctx, act1)
  end

  def greet(_ctx, name) do
    {:ok, "Hello, #{name}!"}
  end
end
