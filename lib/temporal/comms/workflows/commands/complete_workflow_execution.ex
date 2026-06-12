defmodule Temporal.Comms.Workflows.Commands.CompleteWorkflowExecution do
  defstruct result: nil

  alias Temporal.Comms.Payload

  @type t :: %__MODULE__{
          result: Payload.t() | nil
        }

  @type complete_workflow_execution :: {:complete_workflow_execution, Payload.payload()}

  @spec send_to_engine(complete_workflow_execution()) :: t()
  def send_to_engine({:complete_workflow_execution, payload}) do
    {:complete_workflow_execution, %__MODULE__{result: Payload.send_to_engine(payload)}}
  end
end
