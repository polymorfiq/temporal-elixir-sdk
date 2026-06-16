defmodule TemporalEngineNif.Data.RuntimeOpts do
  defstruct [:heartbeat_interval]
  alias TemporalEngine.Data.Duration

  @type t :: %__MODULE__{heartbeat_interval: Duration.duration() | nil}
end
