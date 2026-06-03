defmodule Temporal.CoreSdk.Data.ActivityTaskVariant do
  defstruct start: nil,
            cancel: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          start: Data.ActivityTaskStart.t() | nil,
          cancel: Data.ActivityTaskCancel.t() | nil
        }
end
