defmodule TestWorkflows.Activities do
  use Temporal.Workflow, activities: [:really_long]

  def workflow_with_long_activity(ctx) do
    with {:ok, act} <-
           execute_activity(ctx, &really_long/1, [], start_to_close_timeout: {5, :minutes}) do
      get(act)
    end
  end

  def really_long(_ctx) do
    Process.sleep(60_000)
    :ok
  end
end
