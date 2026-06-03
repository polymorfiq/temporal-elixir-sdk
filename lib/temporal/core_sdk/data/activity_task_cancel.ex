defmodule Temporal.CoreSdk.Data.ActivityTaskCancel do
  defstruct [
    :reason,
    details: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          reason: integer(),
          details: Data.ActivityCancellationDetails.t() | nil
        }
end
