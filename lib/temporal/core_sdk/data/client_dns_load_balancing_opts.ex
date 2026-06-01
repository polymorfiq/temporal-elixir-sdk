defmodule Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts do
  defstruct [:resolution_interval_secs]

  @type t :: %__MODULE__{
          resolution_interval_secs: float()
        }
end
