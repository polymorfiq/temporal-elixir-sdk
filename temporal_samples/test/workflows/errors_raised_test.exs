defmodule TemporalSamples.Workflows.ErrorsRaisedTest do
  use ExUnit.Case, async: true

  alias Temporal.{Workflow, Worker, TaskQueue}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok =
      Worker.register_workflow(
        worker,
        {TemporalSamples.Workflows.ErrorsRaised,
         [:exception_workflow, :error_workflow, :error_with_info_workflow]}
      )
  end

  test "exception is raised", %{queue: queue} do
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "errors-raised-exception",
        {TemporalSamples.Workflows.ErrorsRaised, :exception_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1]
      )

    assert {:error, %{failure: %{message: "Crash the workflow before it finishes"}}} =
             Workflow.result(handle, timeout: {1, :seconds})
  end

  test "error tuple is returned", %{queue: queue} do
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "errors-returned",
        {TemporalSamples.Workflows.ErrorsRaised, :error_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1]
      )

    assert {:error, "Error returned from function"} =
             Workflow.result(handle, timeout: {1, :seconds})
  end

  test "error tuple containing Application Failure, applies that info", %{queue: queue} do
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "errors-returned-with-info",
        {TemporalSamples.Workflows.ErrorsRaised, :error_with_info_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1]
      )

    assert {:error,
            %{
              error_code: :workflow_failed,
              failure: %{
                type: :application,
                info: %{
                  details: ["Some Info"],
                  non_retryable: true,
                  next_retry_delay: {10, :seconds}
                }
              }
            }} =
             Workflow.result(handle, timeout: {1, :seconds})
  end

  defp configure_task_queue(_), do: %{task_queue: "#{__MODULE__}"}
end
