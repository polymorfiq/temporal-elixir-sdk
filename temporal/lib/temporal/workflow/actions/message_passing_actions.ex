defmodule Temporal.Workflow.MessagePassingActions do
  require Temporal.WorkflowContext

  alias Temporal.Workflow.WorkflowExecution
  alias Temporal.WorkflowContext

  @type handler_name :: atom() | String.t()

  @spec set_query_handler(
          WorkflowContext.t(),
          handler_name(),
          handler :: (... -> {:ok, term()} | {:error, term()})
        ) :: :ok
  def set_query_handler(ctx, name, handler) do
    exec = WorkflowContext.workflow_context(ctx, :execution)
    WorkflowExecution.set_query_handler(exec, "#{name}", handler)
  end

  @spec set_update_handler(
          WorkflowContext.t(),
          handler_name(),
          handler :: (... -> {:ok, term()} | {:error, term()}),
          opts :: WorkflowExecution.update_handler_opts()
        ) :: :ok
  def set_update_handler(ctx, name, handler, opts \\ []) do
    exec = WorkflowContext.workflow_context(ctx, :execution)
    WorkflowExecution.set_update_handler(exec, "#{name}", handler, opts)
  end

  @spec set_signal_handler(
          WorkflowContext.t(),
          handler_name(),
          handler :: (... -> :ok | {:error, term()})
        ) :: :ok
  def set_signal_handler(ctx, name, handler) do
    exec = WorkflowContext.workflow_context(ctx, :execution)
    WorkflowExecution.set_signal_handler(exec, "#{name}", handler)
  end
end
