defmodule TestWorkflows.Determinism do
  use Temporal.Workflow
  alias Temporal.Workflow

  def execute(ctx) do
    {:ok, Workflow.utc_now(ctx)}
  end
end
