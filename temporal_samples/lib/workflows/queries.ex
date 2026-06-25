defmodule TemporalSamples.Workflows.Queries do
  use Temporal.Workflow
  alias Temporal.{Workflow, WorkflowContext}

  @dialyzer {:no_return, {:execute, 1}}

  @spec execute(WorkflowContext.t()) :: {:ok, 456}
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

    :ok = Workflow.sleep(ctx, {1, :minutes})

    {:ok, 456}
  end
end
