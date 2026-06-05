defmodule Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts do
  defstruct [:resolution_interval_secs]

  @type t :: %__MODULE__{
          resolution_interval_secs: float()
        }

  @type opts :: [{:resolution_interval_secs, float()}]

  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
