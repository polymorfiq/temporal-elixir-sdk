defmodule TemporalSamples.Workflows.ErrorsRaisedTest do
  use ExUnit.Case, async: true

  alias Temporal.{Workflow, Worker}

  # Defined in test/test_helpers.exs
  setup_all [
    :configure_task_queue,
    {WorkflowHelpers, :setup_client},
    {WorkflowHelpers, :setup_worker}
  ]

  setup_all %{worker: worker} do
    :ok =
      Worker.register_workflows(
        worker,
        [
          {TemporalSamples.Workflows.ErrorsRaised, :exception_workflow},
          {TemporalSamples.Workflows.ErrorsRaised, :error_workflow},
          {TemporalSamples.Workflows.ErrorsRaised, :error_with_info_workflow}
        ]
      )
  end

  test "exception is raised", ctx do
    {:ok, handle} =
      Temporal.Client.execute_workflow(
        ctx.client,
        {TemporalSamples.Workflows.ErrorsRaised, :exception_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1],
        workflow_id: "errors-raised-exception",
        task_queue: ctx.task_queue
      )

    assert {:error, %{message: "Crash the workflow before it finishes"}} =
             Workflow.result(handle, timeout: {1, :seconds})
  end

  test "error tuple is returned", ctx do
    {:ok, handle} =
      Temporal.Client.execute_workflow(
        ctx.client,
        {TemporalSamples.Workflows.ErrorsRaised, :error_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1],
        workflow_id: "errors-returned",
        task_queue: ctx.task_queue
      )

    assert {:error, "Error returned from function"} =
             Workflow.result(handle, timeout: {1, :seconds})
  end

  test "error tuple containing Application Failure, applies that info", ctx do
    {:ok, handle} =
      Temporal.Client.execute_workflow(
        ctx.client,
        {TemporalSamples.Workflows.ErrorsRaised, :error_with_info_workflow},
        [],
        id_reuse_policy: :terminate_if_running,
        retry_policy: [maximum_attempts: 1],
        workflow_id: "errors-returned-with-info",
        task_queue: ctx.task_queue
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
