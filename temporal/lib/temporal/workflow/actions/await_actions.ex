defmodule Temporal.Workflow.AwaitActions do
  import Temporal.WorkflowContext

  alias Temporal.Workflow.WorkflowRuntime
  alias Temporal.Workflow.WorkflowExecution
  alias Temporal.WorkflowContext

  @spec await(WorkflowContext.t(), (-> boolean())) :: :ok
  def await(ctx, await_check) do
    workflow_context(execution: exec) = ctx
    WorkflowExecution.await(exec, await_check)
  end

  @spec all_handlers_finished?(WorkflowContext.t()) :: boolean()
  def all_handlers_finished?(ctx) do
    workflow_context(runtime: runtime) = ctx
    WorkflowRuntime.all_handlers_finished?(runtime)
  end
end
