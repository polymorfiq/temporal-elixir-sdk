defmodule Temporal.CoreSdk.Data.WorkflowChildExecutionStatus do
  defstruct completed: nil, failed: nil, cancelled: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          completed: Data.WorkflowChildExecutionCompletedStatus.t() | nil,
          failed: Data.WorkflowChildExecutionFailedStatus.t() | nil,
          cancelled: Data.WorkflowChildExecutionCancelledStatus.t() | nil
        }
end
