defmodule Temporal.CoreSdk.Data.ActivityResolutionStatus do
  defstruct completed: nil, failed: nil, cancelled: nil, backoff: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          completed: Data.ActivityResolutionCompletedStatus.t() | nil,
          failed: Data.ActivityResolutionFailedStatus.t() | nil,
          cancelled: Data.ActivityResolutionCancelledStatus.t() | nil,
          backoff: Data.ActivityResolutionBackoffStatus.t() | nil
        }
end
