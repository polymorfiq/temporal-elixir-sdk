defmodule TemporalSamples.Workflows.Timers do
  use Temporal.Workflow
  alias Temporal.Workflow
  alias TemporalEngine.Data.Duration

  @spec execute(Workflow.WorkflowContext.t(), Duration.shorthand()) :: {:ok, {:json, integer()}}
  def execute(ctx, wait_duration) do
    {:ok, timer} = Workflow.new_timer(ctx, wait_duration)

    before_wait = DateTime.utc_now()
    Workflow.get(ctx, timer)

    after_wait = DateTime.utc_now()

    # Let's return it as JSON-encoded so it's easy to read in Temporal Server UI
    {:ok, {:json, DateTime.diff(after_wait, before_wait, :millisecond)}}
  end
end
