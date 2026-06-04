defprotocol Temporal.Workflow do
  alias Temporal.Workflows.WorkflowExecHandle

  @spec execute(t(), args :: [term()]) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def execute(_workflow, _args)
end
