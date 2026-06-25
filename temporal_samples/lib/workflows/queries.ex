defmodule TemporalSamples.Workflows.Queries do
  use Temporal.Workflow
  alias Temporal.Workflow

  def execute(ctx) do
    Workflow.set_query_handler(ctx, :no_args, fn ->
      {:ok, "No args!"}
    end)

    Workflow.set_query_handler(ctx, :with_args, fn a ->
      {:ok, "One Arg: #{inspect(a)}"}
    end)

    Workflow.set_query_handler(ctx, :with_args, fn a, b ->
      {:ok, "Two Args: #{inspect(a)}, #{inspect(b)}"}
    end)

    Workflow.set_query_handler(ctx, :throws_exeception, fn ->
      raise "Some exception"
    end)

    Workflow.set_query_handler(ctx, :returns_error, fn ->
      {:error, "Some error"}
    end)

    {:ok, timer} = Workflow.new_timer(ctx, {5, :minutes})
    Workflow.get(timer)

    {:ok, 456}
  end
end
