defmodule TemporalEngineNif.Data.WorkflowFailureInfo do
  defstruct application: nil,
            timeout: nil,
            canceled: nil,
            terminated: nil,
            server: nil,
            reset_workflow: nil,
            activity: nil,
            child_execution: nil,
            nexus_operation: nil,
            nexus_handler: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          application: Data.WorkflowApplicationFailureInfo.t() | nil,
          timeout: Data.WorkflowTimeoutFailureInfo.t() | nil,
          canceled: Data.WorkflowCanceledFailureInfo.t() | nil,
          terminated: Data.WorkflowTerminatedFailureInfo.t() | nil,
          server: Data.WorkflowServerFailureInfo.t() | nil,
          reset_workflow: Data.WorkflowResetFailureInfo.t() | nil,
          activity: Data.WorkflowActivityFailureInfo.t() | nil,
          child_execution: Data.WorkflowChildExecutionFailureInfo.t() | nil,
          nexus_operation: Data.WorkflowNexusOperationFailureInfo.t() | nil,
          nexus_handler: Data.WorkflowNexusHandlerFailureInfo.t() | nil
        }

  @type opts :: []

  def with_opts!(_opts) do
    raise "Not implemented!"
  end
end
