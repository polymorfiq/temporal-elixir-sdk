defmodule TestWorkflows.Activities do
  use Temporal.Workflow,
    activities: [really_long: 1]

  alias Temporal.Workflow

  def workflow_with_long_activity(ctx) do
    with {:ok, act} <-
           Workflow.execute_activity(ctx, &really_long/1, [],
             start_to_close_timeout: [seconds: 300]
           ) do
      Workflow.get(ctx, act)
    end
  end

  def really_long(_ctx) do
    Process.sleep(60_000)
    :ok
  end
end
