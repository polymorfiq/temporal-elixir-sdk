defmodule TemporalEngineNif.Data.WorkflowExecution do
  defstruct [:workflow_id, :run_id]

  import TemporalEngine.Data.Jobs

  @type t :: %__MODULE__{
          workflow_id: String.t(),
          run_id: String.t()
        }

  @spec to_record(t() | nil) :: Jobs.run() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{workflow_id: workflow_id, run_id: run_id}) do
    run(workflow_id: workflow_id, run_id: run_id)
  end
end
