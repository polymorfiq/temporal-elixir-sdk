defmodule TemporalEngineNif.Data.ClientDnsLoadBalancingOpts do
  defstruct [:resolution_interval]

  alias TemporalEngine.Data.Duration

  @type t :: %__MODULE__{
          resolution_interval: Duration.t()
        }
end
