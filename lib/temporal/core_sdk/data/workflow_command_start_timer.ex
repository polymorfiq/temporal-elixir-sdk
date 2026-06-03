defmodule Temporal.CoreSdk.Data.WorkflowCommandStartTimer do
  defstruct [:seq, start_to_fire_timeout: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          start_to_fire_timeout: Data.Duration.t() | nil
        }
end
