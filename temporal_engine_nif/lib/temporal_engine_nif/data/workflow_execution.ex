defmodule TemporalEngineNif.Data.WorkflowExecution do
  defstruct [:workflow_id, :run_id]

  import TemporalEngine.Data.Common

  @type t :: %__MODULE__{
          workflow_id: String.t(),
          run_id: String.t()
        }

  @spec to_record(t() | nil) :: Common.workflow_execution() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{workflow_id: workflow_id, run_id: run_id}) do
    workflow_execution(workflow_id: workflow_id, run_id: run_id)
  end

  @spec from_record(Common.workflow_execution() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(workflow_execution(workflow_id: workflow_id, run_id: run_id)) do
    %__MODULE__{workflow_id: workflow_id, run_id: run_id}
  end
end
