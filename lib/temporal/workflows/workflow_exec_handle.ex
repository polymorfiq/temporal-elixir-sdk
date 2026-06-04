defmodule Temporal.Workflows.WorkflowExecHandle do
end

defimpl Temporal.Workflows.WorkflowExecution, for: Temporal.Workflows.WorkflowExecHandle do
  @impl true
  def status(_exec), do: :running
end
