defmodule Temporal.CoreSdk.Data.WorkflowCommandRequestCancelExternalWorkflowExecution do
  defstruct [:seq, :reason, workflow_execution: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          workflow_execution: Data.WorkflowNamespacedExecution.t() | nil,
          reason: String.t()
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:workflow_execution, Data.WorkflowNamespacedExecution.opts()}
          | {:reason, String.t()}
        ]
  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    req = struct!(__MODULE__, opts)

    req =
      if opts[:workflow_execution] do
        update_in(
          req,
          [Access.key(:workflow_execution)],
          &Data.WorkflowNamespacedExecution.with_opts!/1
        )
      else
        req
      end

    req
  end
end
