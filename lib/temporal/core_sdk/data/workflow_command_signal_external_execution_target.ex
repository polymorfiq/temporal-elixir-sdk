defmodule Temporal.CoreSdk.Data.WorkflowCommandSignalExternalExecutionTarget do
  defstruct workflow_execution: nil, child_workflow_id: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          workflow_execution: Data.WorkflowNamespacedExecution.t() | nil,
          child_workflow_id: String.t() | nil
        }

  @type opts :: [
          {:workflow_execution, Data.WorkflowNamespacedExecution.opts()}
          | {:child_workflow_id, String.t()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    target = struct!(__MODULE__, opts)

    target =
      if opts[:workflow_execution] do
        update_in(
          target,
          [Access.key(:workflow_execution)],
          &Data.WorkflowNamespacedExecution.with_opts!/1
        )
      else
        target
      end

    target
  end
end
