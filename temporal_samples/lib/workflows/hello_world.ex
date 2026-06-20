defmodule TemporalSamples.Workflows.HelloWorld do
  @moduledoc """
  This shows a basic example of defining a workflow and an activity.
  It then shows calling an activity (asynchronous) and then waiting for its result (synchronously).

  Look in [test/workflows/hello_world_test.exs](test/workflows/hello_world_test.exs) for usage.
  """

  use Temporal.Workflow, activities: [greet: 2]
  alias Temporal.Workflow

  @doc "The main body of the workflow"
  def execute(ctx, name) do
    # Schedule activity (non-blocking)
    {:ok, act1} =
      Workflow.execute_activity(ctx, &greet/2, [name], start_to_close_timeout: [seconds: 1])

    # Get result of activity (blocks until finished).
    {:ok, msg} = Workflow.get(ctx, act1)

    # Output result of activity
    {:ok, msg}
  end

  @doc "A simple activity, marked as such by the use Temporal.Workflow, [activities: ...] above."
  def greet(_ctx, name) do
    {:ok, "Hello, #{name}!"}
  end
end
