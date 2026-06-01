defmodule Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts do
  defstruct [:simple_maximum]

  @type t :: %__MODULE__{
          simple_maximum: pos_integer()
        }
end
