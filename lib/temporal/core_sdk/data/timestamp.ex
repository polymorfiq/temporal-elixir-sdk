defmodule Temporal.CoreSdk.Data.Timestamp do
  defstruct [
    :seconds,
    :nanos
  ]

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}
end
