defmodule TestWorkflows.TimerWithAwait do
  use Temporal.Workflow

  alias Temporal.Workflow

  def execute(ctx) do
    {:ok, timer} = Workflow.new_timer(ctx, {100, :milliseconds})
    Workflow.get(ctx, timer)

    {:ok, "Waited!"}
  end
end
