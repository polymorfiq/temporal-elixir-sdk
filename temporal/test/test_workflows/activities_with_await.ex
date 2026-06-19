defmodule TestWorkflows.ActivitiesWithAwait do
  use Temporal.Workflow,
    activities: [
      {:greet_activity, 2, [name: "activity_a"]},
      {:greet_activity, 2, [name: "activity_b"]}
    ]

  alias Temporal.Workflow

  def execute(ctx, msg) do
    {:ok, act1} =
      Workflow.execute_activity(ctx, "activity_a", ["#{msg}1"],
        start_to_close_timeout: [seconds: 1]
      )

    {:ok, act2} =
      Workflow.execute_activity(ctx, "activity_b", ["#{msg}2"],
        start_to_close_timeout: [seconds: 1]
      )

    Workflow.get(ctx, act1)
    Workflow.get(ctx, act2)
  end

  def greet_activity(_ctx, msg) do
    {:ok, "Hello, #{msg}!"}
  end
end
