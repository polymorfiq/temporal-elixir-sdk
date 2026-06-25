defmodule TemporalSamples.Workflows.TimersTest do
  use ExUnit.Case, async: true

  alias Temporal.{Workflow, Worker}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok = Worker.register_workflows(worker, [TemporalSamples.Workflows.Timers])
  end

  test "respects timer duration", ctx do
    {:ok, handle_5k} =
      Temporal.Client.execute_workflow(
        ctx.client,
        TemporalSamples.Workflows.Timers,
        [{5, :seconds}],
        id: "timers-1-5s",
        id_reuse_policy: :terminate_if_running,
        task_queue: ctx.task_queue
      )

    {:ok, waited_5k_ms} = Workflow.result(handle_5k)

    assert_in_delta waited_5k_ms,
                    5000,
                    1500,
                    "Actual timer duration (#{waited_5k_ms}ms) was not within error bounds of 5s (+- 1.5 seconds)"
  end

  test "respects (short) timer duration", ctx do
    {:ok, handle_250} =
      Temporal.Client.execute_workflow(
        ctx.client,
        TemporalSamples.Workflows.Timers,
        [{250, :milliseconds}],
        id: "timers-1-250ms",
        id_reuse_policy: :terminate_if_running,
        task_queue: ctx.task_queue
      )

    {:ok, waited_250_ms} = Workflow.result(handle_250)

    assert_in_delta waited_250_ms,
                    250,
                    1000,
                    "Actual timer duration (#{waited_250_ms}ms) was not within error bounds of 250ms (+- 1.0 seconds)"
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
