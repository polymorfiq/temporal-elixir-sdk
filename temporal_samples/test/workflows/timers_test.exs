defmodule TemporalSamples.Workflows.TimersTest do
  use ExUnit.Case, async: true

  alias Temporal.{Workflow, Worker, TaskQueue}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok = Worker.register_workflow(worker, TemporalSamples.Workflows.Timers)
  end

  test "respects timer duration", %{queue: queue} do
    {:ok, handle_5k} =
      TaskQueue.start_workflow(
        queue,
        "timers-1-5s",
        TemporalSamples.Workflows.Timers,
        [[seconds: 5]],
        id_reuse_policy: :terminate_if_running
      )

    {:ok, waited_5k_ms} = Workflow.result(handle_5k)

    assert_in_delta waited_5k_ms,
                    5000,
                    1500,
                    "Actual timer duration (#{waited_5k_ms}ms) was not within error bounds of 5s (+- 1.5 seconds)"
  end

  test "respects (short) timer duration", %{queue: queue} do
    {:ok, handle_250} =
      TaskQueue.start_workflow(
        queue,
        "timers-1-250ms",
        TemporalSamples.Workflows.Timers,
        [[nanos: 250_000_000]],
        id_reuse_policy: :terminate_if_running
      )

    {:ok, waited_250_ms} = Workflow.result(handle_250)

    assert_in_delta waited_250_ms,
                    250,
                    1000,
                    "Actual timer duration (#{waited_250_ms}ms) was not within error bounds of 250ms (+- 1.0 seconds)"
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
