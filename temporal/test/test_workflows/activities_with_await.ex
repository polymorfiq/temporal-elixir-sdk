defmodule TestWorkflows.ActivitiesWithAwait do
  use Temporal.Workflow,
    activities: [
      {:greet_activity, [name: "activity_a"]},
      {:greet_activity, [name: "activity_b"]}
    ]

  def execute(ctx, msg) do
    {:ok, act1} =
      execute_activity(ctx, "activity_a", ["#{msg}1"], start_to_close_timeout: [seconds: 1])

    {:ok, act2} =
      execute_activity(ctx, "activity_b", ["#{msg}2"], start_to_close_timeout: [seconds: 1])

    get(act1)
    get(act2)
  end

  def greet_activity(_ctx, msg) do
    {:ok, "Hello, #{msg}!"}
  end
end
