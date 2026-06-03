defmodule Temporal.CoreSdk.Data.Duration do
  defstruct [
    :seconds,
    :nanos
  ]

  @type t :: %__MODULE__{seconds: integer(), nanos: integer()}
end
