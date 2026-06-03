defmodule Temporal.CoreSdk.Data.ActivityTask do
  defstruct [
    :task_token,
    variant: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{task_token: [byte()], variant: Data.ActivityTaskVariant.t() | nil}
end
