defmodule Temporal.Comms.Workflows.Commands.FailWorkflowExecution do
  defstruct failure: nil

  @type fail_workflow_execution ::
          {:fail_workflow_execution, message :: String.t(), workflow_failure_opts()}

  @type workflow_failure_opts :: [
          {:source, String.t()}
          | {:stack_trace, String.t()}
          | {:encoded_attributes, Data.Payload.opts()}
          | {:cause, workflow_failure_opts()}
          | {:failure_info, Data.WorkflowFailureInfo.opts()}
        ]

  alias Temporal.Comms.Shared.Failure

  @type t :: %__MODULE__{
          failure: Failure.t() | nil
        }

  @spec send_to_engine(fail_workflow_execution()) :: t()
  def send_to_engine({:fail_workflow_execution, message}),
    do: send_to_engine({:fail_workflow_execution, message, []})

  def send_to_engine({:fail_workflow_execution, message, opts}) do
    {:fail_workflow_execution,
     %__MODULE__{failure: Failure.send_to_engine({:failure, message, opts})}}
  end
end
