defmodule Temporal.CoreSdk.Data.RuntimeOpts do
  defstruct [:heartbeat_interval_secs]

  @type t :: %__MODULE__{heartbeat_interval_secs: pos_integer() | nil}
end
