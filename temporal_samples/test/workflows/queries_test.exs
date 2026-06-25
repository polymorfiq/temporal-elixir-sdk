defmodule TemporalSamples.Workflows.QueriesTest do
  use ExUnit.Case

  alias Temporal.{Client, Worker}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok = Worker.register_workflows(worker, [TemporalSamples.Workflows.Queries])
  end

  setup [:start_workflow]

  test "can execute with no arguments", ctx do
    assert {:ok, "No args!"} = Client.query_workflow(ctx.handle, :no_args)
  end

  test "can execute with arguments", ctx do
    assert {:ok, "One Arg: 123"} = Client.query_workflow(ctx.handle, :with_args, [123])
    assert {:ok, "Two Args: 123, 456"} = Client.query_workflow(ctx.handle, :with_args, [123, 456])
  end

  test "returns error when given too many arguments", ctx do
    assert {:error, _} = Client.query_workflow(ctx.handle, :with_args, [:too, :many, :args])
  end

  test "returns error when given invalid Query Type", ctx do
    assert {:error, _} = Client.query_workflow(ctx.handle, :not_real_query_handler)
  end

  test "returns error when query raises exception", ctx do
    assert {:error, %{message: ~s|%RuntimeError{message: "Some exception"}|}} =
             Client.query_workflow(ctx.handle, :throws_exeception)
  end

  test "forwards error when query returns {:error, ...}", ctx do
    assert {:error, "Some error"} = Client.query_workflow(ctx.handle, :returns_error)
  end

  defp start_workflow(ctx) do
    {:ok, wf} =
      Client.execute_workflow(
        ctx.client,
        TemporalSamples.Workflows.Queries,
        [],
        id: "set-query-handler",
        id_conflict_policy: :terminate_existing,
        task_queue: ctx.task_queue
      )

    Map.put(ctx, :handle, wf)
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
