defmodule Temporal.CoreSdk.Data.WorkflowCommandSignalExternalWorkflowExecution do
  defstruct [
    :seq,
    :signal_name,
    :args,
    :headers,
    target: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          signal_name: String.t(),
          args: [Data.ActivationPayload.t()],
          headers: map(),
          target: Data.WorkflowCommandSignalExternalExecutionTarget.t() | nil
        }
end
