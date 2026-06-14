defmodule TemporalEngineNif.Data.WorkflowCommandSignalExternalWorkflowExecution do
  defstruct [
    :seq,
    :signal_name,
    args: [],
    headers: %{},
    target: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          signal_name: String.t(),
          args: [Data.Payload.t()],
          headers: %{String.t() => Data.Payload.t()},
          target: Data.WorkflowCommandSignalExternalExecutionTarget.t() | nil
        }
end
