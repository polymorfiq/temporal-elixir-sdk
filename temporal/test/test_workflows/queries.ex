defmodule TestWorkflows.Queries do
  use Temporal.Workflow,
    activities: [really_long: 1]

  alias Temporal.Workflow

  def execute(ctx) do
    Workflow.query_handler(ctx, :my_query, fn ->
      {:ok, 123}
    end)

    {:ok, 456}
  end
end
