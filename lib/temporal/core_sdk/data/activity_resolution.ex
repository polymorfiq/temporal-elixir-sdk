defmodule Temporal.CoreSdk.Data.ActivityResolution do
  defstruct status: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{status: Data.ActivityResolutionStatus.t() | nil}
end
