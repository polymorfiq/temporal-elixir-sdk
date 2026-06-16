defmodule TemporalEngineNif.Data.ActivityExecutionStatus do
  alias TemporalEngineNif.Data

  @type t ::
          {:completed, Data.ActivityExecutionSuccess.t()}
          | {:failed, Data.ActivityExecutionFailure.t()}
          | {:cancelled, Data.ActivityExecutionCancellation.t()}
          | {:will_complete_async, Data.ActivityExecutionWillCompleteAsync.t()}
end
