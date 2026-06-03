defmodule Temporal.CoreSdk.Data.ActivityExecutionStatus do
  defstruct completed: nil,
            failed: nil,
            cancelled: nil,
            will_complete_async: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          completed: Data.ActivityExecutionSuccess.t() | nil,
          failed: Data.ActivityExecutionFailure.t() | nil,
          cancelled: Data.ActivityExecutionCancellation.t() | nil,
          will_complete_async: Data.ActivityExecutionWillCompleteAsync.t() | nil
        }
end
