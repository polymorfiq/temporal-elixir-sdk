defmodule TemporalEngineNif.Data.WorkflowChildExecutionFailureInfo do
  defstruct [
    :namespace,
    :initiated_event_id,
    :started_event_id,
    :retry_state,
    workflow_execution: nil,
    workflow_type: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          namespace: String.t(),
          workflow_execution: Data.WorkflowExecution.t() | nil,
          workflow_type: Data.WorkflowType.t() | nil,
          initiated_event_id: integer(),
          started_event_id: integer(),
          retry_state: integer()
        }
end
