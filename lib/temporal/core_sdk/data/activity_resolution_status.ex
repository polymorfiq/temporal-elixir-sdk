defmodule Temporal.CoreSdk.Data.ActivityResolutionStatus do
  defstruct completed: nil, failed: nil, cancelled: nil, backoff: nil

  alias Temporal.CoreSdk.Data

  @type t ::
          {:completed, Data.ActivityResolutionCompletedStatus.t()}
          | {:failed, Data.ActivityResolutionFailedStatus.t()}
          | {:cancelled, Data.ActivityResolutionCancelledStatus.t()}
          | {:backoff, Data.ActivityResolutionBackoffStatus.t()}
end
