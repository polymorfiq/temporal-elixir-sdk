defmodule TemporalEngineNif.Data.ClientKeepAliveOpts do
  defstruct [:interval, :timeout]

  alias TemporalEngineNif.Data.Duration

  @type t :: %__MODULE__{
          interval: Duration.t(),
          timeout: Duration.t()
        }
end
