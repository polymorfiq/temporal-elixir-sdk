defmodule TemporalSamples.Workflows.LocalActivities do
  use Temporal.Workflow, activities: [greet: 2]
  alias Temporal.Workflow

  def execute(ctx, name) do
    {:ok, act1} =
      Workflow.execute_local_activity(ctx, &greet/2, [name], start_to_close_timeout: [seconds: 1])

    Workflow.get(ctx, act1)
  end

  def greet(_ctx, name) do
    {:ok, "Hello, #{name}!"}
  end
end
