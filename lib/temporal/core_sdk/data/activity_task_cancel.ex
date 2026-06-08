defmodule Temporal.CoreSdk.Data.ActivityTaskCancel do
  defstruct [
    :reason,
    details: nil
  ]

  alias Temporal.CoreSdk.Data

  @type cancel_reason() ::
          :not_found | :cancelled | :timed_out | :worker_shutdown | :paused | :reset
  @type t :: %__MODULE__{
          reason: cancel_reason(),
          details: Data.ActivityCancellationDetails.t() | nil
        }
end
