defmodule Temporal.CoreSdk.Data.ActivityTaskCompletion do
  defstruct [
    :task_token,
    result: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          task_token: [byte()],
          result: Data.ActivityExecutionResult.t() | nil
        }
end
