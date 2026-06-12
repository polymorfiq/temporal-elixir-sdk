defmodule Temporal.Comms.Workflows.WorkflowExecution do
  defstruct [:workflow_id, :run_id]

  @type t :: %__MODULE__{
          workflow_id: String.t(),
          run_id: String.t()
        }

  @type execution :: {:execution, workflow_id(), run_id()}
  @type workflow_id :: String.t()
  @type run_id :: String.t()

  @spec send_to_sdk(t()) :: execution()
  def send_to_sdk(%__MODULE__{} = exec) do
    {:execution, exec.workflow_id, exec.run_id}
  end

  @spec send_to_engine(execution()) :: t()
  def send_to_engine({:execution, workflow_id, run_id}) do
    %__MODULE__{workflow_id: workflow_id, run_id: run_id}
  end
end
