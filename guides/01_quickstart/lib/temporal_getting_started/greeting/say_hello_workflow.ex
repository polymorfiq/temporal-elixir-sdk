defmodule TemporalGettingStarted.Greeting.SayHelloWorkflow do
  use Temporal.Workflow

  alias Temporal.{Workflow, WorkflowContext}
  alias TemporalGettingStarted.Greeting

  @spec execute(WorkflowContext.t(), name :: String.t()) :: {:ok, String.t()} | {:error, term()}
  def execute(ctx, name) do
    ctx = Workflow.with_activity_opts(ctx, start_to_close_timeout: {10, :seconds})

    with  {:ok, activity} <- Workflow.execute_activity(ctx, &Greeting.greet/1, [name]) do
      Workflow.get(ctx, activity)
    end
  end
end