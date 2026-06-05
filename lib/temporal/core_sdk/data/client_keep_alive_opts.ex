defmodule Temporal.CoreSdk.Data.ClientKeepAliveOpts do
  defstruct [:interval_secs, :timeout_secs]

  @type t :: %__MODULE__{
          interval_secs: float(),
          timeout_secs: float()
        }

  @type opts :: [{:interval_secs, float()} | {:timeout_secs, float()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
