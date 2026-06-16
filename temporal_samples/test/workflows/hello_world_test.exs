defmodule TemporalSamples.Workflows.HelloWorldTest do
  use ExUnit.Case

  alias Temporal.{Workflow, Worker, TaskQueue}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok = Worker.register_workflow(worker, TemporalSamples.Workflows.HelloWorld)
  end

  test "greets the world", %{queue: queue} do
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "hello-world-1",
        TemporalSamples.Workflows.HelloWorld,
        ["World"],
        id_reuse_policy: :terminate_if_running
      )

    {:ok, "Hello, World!"} = Workflow.result(handle)
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
