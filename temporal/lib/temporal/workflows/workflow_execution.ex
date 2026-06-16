defprotocol Temporal.Workflows.WorkflowExecution do
  @spec status(t()) :: {:ok, :succeeded | :failed | :cancelled | :running} | {:error, term()}
  def status(_exec)
end
