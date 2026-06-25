defmodule TestWorkflows.Queries do
  use Temporal.Workflow

  alias Temporal.Workflow

  def execute(ctx) do
    Workflow.set_query_handler(ctx, :no_args, fn ->
      {:ok, "No args!"}
    end)

    Workflow.set_query_handler(ctx, :with_args, fn arg ->
      {:ok, "Args: #{inspect(arg)}"}
    end)

    Workflow.set_query_handler(ctx, :throws_exeception, fn ->
      raise "Some exception"
    end)

    Workflow.set_query_handler(ctx, :returns_error, fn ->
      {:error, "Some error"}
    end)

    :ok = Workflow.sleep(ctx, {1, :minutes})

    {:ok, 456}
  end
end
