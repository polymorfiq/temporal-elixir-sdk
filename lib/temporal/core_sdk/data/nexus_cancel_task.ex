defmodule Temporal.CoreSdk.Data.NexusCancelTask do
  defstruct [
    :task_token,
    :reason
  ]

  @type t :: %__MODULE__{
          task_token: [byte()],
          reason: integer()
        }
end
