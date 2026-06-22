defmodule TemporalSamples.Workflows.ErlangTermFormatTest do
  use ExUnit.Case

  alias Temporal.{Workflow, Worker}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok = Worker.register_workflows(worker, [TemporalSamples.Workflows.ErlangTermFormat])
  end

  test "greets the world (Erlang style)", ctx do
    {:ok, handle} =
      Temporal.Client.execute_workflow(
        ctx.client,
        TemporalSamples.Workflows.ErlangTermFormat,
        [[name: "World", first_name: "Bob", last_name: "Smith"]],
        id_reuse_policy: :terminate_if_running,
        workflow_id: "erlang-term-format-3",
        task_queue: ctx.task_queue
      )

    {:ok, ["Hello, World!", "Hello, Bob Smith!"]} = Workflow.result(handle)
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
