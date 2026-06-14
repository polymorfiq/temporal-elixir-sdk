defmodule TemporalEngineNif.Data.WorkflowCommandQueryResultVariant do
  alias TemporalEngineNif.Data

  @type t ::
          {:succeeded, Data.WorkflowCommandQuerySuccess.t()} | {:failed, Data.WorkflowFailure.t()}
end
