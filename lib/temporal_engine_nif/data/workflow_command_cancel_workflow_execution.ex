defmodule TemporalEngineNif.Data.WorkflowCommandCancelWorkflowExecution do
  defstruct []

  @type t :: %__MODULE__{}
  @type opts :: []

  @spec with_opts!(opts()) :: t()
  def with_opts!(_opts), do: %__MODULE__{}
end
