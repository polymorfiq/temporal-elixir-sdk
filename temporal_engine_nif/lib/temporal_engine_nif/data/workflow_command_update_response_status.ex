defmodule TemporalEngineNif.Data.WorkflowCommandUpdateResponseStatus do
  alias TemporalEngineNif.Data

  @type t ::
          {:accepted, bool()}
          | {:rejected, Data.WorkflowFailure.t()}
          | {:completed, Data.Payload.t()}
end
