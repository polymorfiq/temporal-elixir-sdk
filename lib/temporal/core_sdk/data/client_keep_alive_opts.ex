defmodule Temporal.CoreSdk.Data.ClientKeepAliveOpts do
  defstruct [:interval_secs, :timeout_secs]

  @type t :: %__MODULE__{
          interval_secs: float(),
          timeout_secs: float()
        }
end
