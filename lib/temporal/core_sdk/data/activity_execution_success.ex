defmodule Temporal.CoreSdk.Data.ActivityExecutionSuccess do
  defstruct result: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          result: Data.Payload.t() | nil
        }
end
